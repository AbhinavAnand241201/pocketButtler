import Foundation
import Combine
import CoreLocation
import MapKit
import SwiftUI

// Define APIError for the mock service
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
    case unauthorized
    case serverError(Int)
    case unknown
}

// Mock API service for previews
class MockAPIService {
    static let shared = MockAPIService()
    
    private init() {}
    
    // Mock items for previews
    let mockItems: [Item] = [
        Item(
            id: "1",
            name: "House Keys",
            location: "Kitchen Counter",
            ownerId: "user123",
            timestamp: Date().addingTimeInterval(-3600),
            photoUrl: nil,
            isFavorite: true,
            coordinates: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        ),
        Item(
            id: "2",
            name: "Wallet",
            location: "Bedroom Drawer",
            ownerId: "user123",
            timestamp: Date().addingTimeInterval(-7200),
            photoUrl: nil,
            isFavorite: false,
            coordinates: CLLocationCoordinate2D(latitude: 37.7750, longitude: -122.4180)
        ),
        Item(
            id: "3",
            name: "Headphones",
            location: "Office Desk",
            ownerId: "user123",
            timestamp: Date().addingTimeInterval(-10800),
            photoUrl: nil,
            isFavorite: true,
            coordinates: CLLocationCoordinate2D(latitude: 37.7752, longitude: -122.4170)
        )
    ]
    
    // Mock request that returns sample data for previews
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil
    ) -> AnyPublisher<T, APIError> {
        // Simulate network delay
        return Future<T, APIError> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Return mock data based on the endpoint and type
                if endpoint.contains("/items") {
                    if T.self == [Item].self {
                        promise(.success(self.mockItems as! T))
                    } else if T.self == Item.self {
                        promise(.success(self.mockItems[0] as! T))
                    } else {
                        promise(.failure(.decodingFailed(NSError(domain: "MockAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data available for this type"]))))
                    }
                } else if endpoint.contains("/auth") {
                    // Mock auth response if needed
                    let mockAuthResponse = ["token": "mock_token", "user": ["id": "user123", "name": "Test User", "email": "test@example.com"]]
                    do {
                        let data = try JSONSerialization.data(withJSONObject: mockAuthResponse)
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        promise(.success(decoded))
                    } catch {
                        promise(.failure(.decodingFailed(error)))
                    }
                } else {
                    // Default empty response
                    if method == "DELETE" {
                        // For delete operations, return an empty response
                        let emptyResponse = ItemEmptyResponse()
                        if let response = emptyResponse as? T {
                            promise(.success(response))
                        } else {
                            promise(.failure(.decodingFailed(NSError(domain: "MockAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cannot convert empty response to requested type"]))))
                        }
                    } else {
                        promise(.failure(.invalidURL))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// Empty response for DELETE operations in mock service
fileprivate struct ItemEmptyResponse: Decodable {}
