import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared
    private var refreshTokenTimer: Timer?
    
    init() {
        // Check for existing token and validate it
        checkAuthStatus()
    }
    
    deinit {
        refreshTokenTimer?.invalidate()
    }
    
    private func startTokenRefreshTimer() {
        // Refresh token every 14 minutes (tokens expire in 15)
        refreshTokenTimer?.invalidate()
        refreshTokenTimer = Timer.scheduledTimer(withTimeInterval: 14 * 60, repeats: true) { [weak self] _ in
            self?.refreshToken()
        }
    }
    
    private func refreshToken() {
        guard let currentToken = apiService.getCurrentToken() else { return }
        
        apiService.request(
            endpoint: Constants.API.authEndpoint + "/refresh",
            method: "POST",
            body: ["token": currentToken]
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                // If refresh fails, log out the user
                self?.logout()
                self?.error = "Session expired. Please log in again."
            }
        } receiveValue: { [weak self] (response: AuthResponse) in
            self?.apiService.setAuthToken(response.token)
            self?.startTokenRefreshTimer()
        }
        .store(in: &cancellables)
    }
    
    // Login with email and password
    func login(email: String, password: String) {
        isLoading = true
        error = nil
        
        let loginData: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        apiService.request(
            endpoint: Constants.API.authEndpoint + "/login",
            method: "POST",
            body: loginData
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            
            if case .failure(let error) = completion {
                self?.error = "Login failed: \(error.localizedDescription)"
            }
        } receiveValue: { [weak self] (response: AuthResponse) in
            self?.apiService.setAuthToken(response.token)
            self?.currentUser = response.user
            self?.isAuthenticated = true
            self?.startTokenRefreshTimer()
        }
        .store(in: &cancellables)
    }
    
    // Register a new user
    func register(name: String, email: String, password: String) {
        isLoading = true
        error = nil
        
        let registerData: [String: Any] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        apiService.request(
            endpoint: Constants.API.authEndpoint + "/register",
            method: "POST",
            body: registerData
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            
            if case .failure(let error) = completion {
                self?.error = "Registration failed: \(error.localizedDescription)"
            }
        } receiveValue: { [weak self] (response: AuthResponse) in
            self?.apiService.setAuthToken(response.token)
            self?.currentUser = response.user
            self?.isAuthenticated = true
            
            // Save token to UserDefaults for persistence
            UserDefaults.standard.set(response.token, forKey: "authToken")
        }
        .store(in: &cancellables)
    }
    
    // Logout the current user
    func logout() {
        apiService.clearAuthToken()
        currentUser = nil
        isAuthenticated = false
        refreshTokenTimer?.invalidate()
        refreshTokenTimer = nil
        
        // Remove token from UserDefaults
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    // Check if user is already logged in (from saved token)
    func checkAuthStatus() {
        guard let token = apiService.getCurrentToken() else {
            isAuthenticated = false
            return
        }
        
        // Validate token with backend
        apiService.request(
            endpoint: Constants.API.authEndpoint + "/validate",
            method: "POST",
            body: ["token": token]
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure = completion {
                self?.logout()
            }
        } receiveValue: { [weak self] (user: User) in
            self?.currentUser = user
            self?.isAuthenticated = true
            self?.startTokenRefreshTimer()
        }
        .store(in: &cancellables)
    }
    
    // For password reset
    func resetPassword(email: String) {
        isLoading = true
        error = nil
        
        let resetData: [String: Any] = [
            "email": email
        ]
        
        apiService.request(
            endpoint: Constants.API.authEndpoint + "/reset-password",
            method: "POST",
            body: resetData
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            
            if case .failure(let error) = completion {
                self?.error = "Password reset failed: \(error.localizedDescription)"
            }
        } receiveValue: { (_: EmptyResponse) in
            // Success message will be handled by the view
        }
        .store(in: &cancellables)
    }
}

// Response structure for auth endpoints
struct AuthResponse: Decodable {
    let token: String
    let user: User
}

// Empty response for endpoints that don't return data
struct EmptyResponse: Decodable {}

