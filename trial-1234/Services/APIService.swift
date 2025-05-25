import Foundation
import Combine
import Security

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
    case unauthorized
    case serverError(Int)
    case unknown
    case forbidden
    case notFound
    case rateLimitExceeded
    case decodingError(Error)
}

class APIService {
    static let shared = APIService()
    private var cancellables = Set<AnyCancellable>()
    private var authToken: String?
    private var requestCounts: [String: (count: Int, timestamp: Date)] = [:]
    private let rateLimit = 100 // requests per minute
    private let rateLimitWindow: TimeInterval = 60 // 1 minute
    
    private init() {
        // Load token from Keychain on init
        authToken = loadTokenFromKeychain()
    }
    
    // MARK: - Token Management
    
    func setAuthToken(_ token: String) {
        self.authToken = token
        saveTokenToKeychain(token)
    }
    
    func clearAuthToken() {
        self.authToken = nil
        deleteTokenFromKeychain()
    }
    
    private func saveTokenToKeychain(_ token: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken",
            kSecValueData as String: token.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        // First try to delete any existing token
        SecItemDelete(query as CFDictionary)
        
        // Then add the new token
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Error saving token to Keychain: \(status)")
            return
        }
    }
    
    private func loadTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken",
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    private func deleteTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken"
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func getCurrentToken() -> String? {
        return authToken
    }
    
    private func checkRateLimit(for endpoint: String) -> Bool {
        let now = Date()
        let key = endpoint
        
        // Clean up old entries
        requestCounts = requestCounts.filter { _, value in
            now.timeIntervalSince(value.timestamp) < rateLimitWindow
        }
        
        // Get current count for endpoint
        let current = requestCounts[key] ?? (count: 0, timestamp: now)
        
        // Update count
        if now.timeIntervalSince(current.timestamp) >= rateLimitWindow {
            // Reset if window has passed
            requestCounts[key] = (count: 1, timestamp: now)
            return true
        } else if current.count < rateLimit {
            // Increment if within limit
            requestCounts[key] = (count: current.count + 1, timestamp: current.timestamp)
            return true
        }
        
        // Rate limit exceeded
        return false
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil
    ) -> AnyPublisher<T, APIError> {
        // Check rate limit for auth endpoints
        if endpoint.contains("/auth/") && !checkRateLimit(for: endpoint) {
            return Fail(error: APIError.rateLimitExceeded)
                .eraseToAnyPublisher()
        }
        
        guard let url = URL(string: Constants.API.baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Add auth header if token exists
        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body if provided
        if let body = body {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                // Handle rate limit response
                if httpResponse.statusCode == 429 {
                    throw APIError.rateLimitExceeded
                }
                
                // Handle other status codes
                switch httpResponse.statusCode {
                case 200...299:
                    return data
                case 401:
                    throw APIError.unauthorized
                case 403:
                    throw APIError.forbidden
                case 404:
                    throw APIError.notFound
                case 500...599:
                    throw APIError.serverError(httpResponse.statusCode)
                default:
                    throw APIError.unknown
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                }
                return APIError.decodingError(error)
            }
            .eraseToAnyPublisher()
    }
}
