import Foundation

// MARK: - Network Login Protocol

/// A protocol that defines a method for logging in a user.
protocol NetworkLoginProtocol {
    func loginUser(user: String, password: String) async throws -> UserModel
}

// MARK: - Network Login Implementation

/// A class that handles the network request for logging in a user.
final class NetworkLogin: NetworkLoginProtocol {
    
    /// Logs in a user by sending a POST request with their credentials.
    /// - Parameters:
    ///   - user: The email address of the user.
    ///   - password: The password entered by the user.
    /// - Returns: Returns a JWT token if the login is successful.
    /// - Throws: Throws an error if the login request fails.
    func loginUser(user: String, password: String) async throws -> UserModel {
        
        var userProfile = UserModel(id: UUID(), name: "", email: "", role: "", token: "")
        
        // Construct the URL for the login endpoint
        let urlCad = "\(ConstantsApp.CONS_API_URL)\(EndPoints.login.rawValue)"
        
        // Ensure the URL is valid
        guard let url = URL(string: urlCad) else {
            throw PKError.badUrl // Throw an error if the URL is invalid
        }
        
        // Create the request body with the user's credentials
        let requestBody = UserLoginRequest(email: user, password: password)
        let jsonData = try JSONEncoder().encode(requestBody) // Encode the request body to JSON
        
        // Create the URL request
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = HttpMethods.post // Set the HTTP method to POST
        request.addValue(HttpMethods.content, forHTTPHeaderField: HttpMethods.contentTypeID) // Set the content type
        request.httpBody = jsonData // Set the body of the request with the encoded data
        
        // Send the request and await the response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Ensure the response is a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PKError.errorFromApi(statusCode: -1) // Throw an error if the response is invalid
        }
        // Check the status code of the response
        guard httpResponse.statusCode == HttpResponseCodes.SUCESS else {
            // Log the error if the response code is not successful
            let errorBody = String(data: data, encoding: .utf8) ?? "Unreadable response body"
            print("Error Code: \(httpResponse.statusCode)")
            print("Error Body: \(errorBody)")
            throw PKError.errorFromApi(statusCode: httpResponse.statusCode) // Throw an error if the status code indicates failure
        }
        
        do {
            // Decode the user data from the response
            let result = try JSONDecoder().decode(UserModel.self, from: data)
            userProfile = result
        } catch {
            // Handle any errors during the login process
            print("Error fetching user: \(error.localizedDescription)")
        }
        
        return userProfile // Return the JWT token
    }
}

// MARK: - Mock Implementations

/// A mock implementation for successfully logging in a user.
final class NetworkLoginMock: NetworkLoginProtocol {
    func loginUser(user: String, password: String) async throws -> UserModel {
        return UserModel(
                    id: UUID(),
                    name: "Test User",
                    email: "test@example.com",
                    role: "admin",
                    token: "mocked_jwt_token"
                )
    }
}

/// A mock implementation that simulates a login failure.
final class NetworkLoginErrorMock: NetworkLoginProtocol {
    func loginUser(user: String, password: String) async throws -> UserModel {
        throw PKError.authenticationFailed // Simulate a login failure with an authentication error
    }
}
