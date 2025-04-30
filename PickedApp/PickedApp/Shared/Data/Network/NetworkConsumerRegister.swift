import Foundation

// MARK: - Network Consumer Register Protocol

/// A protocol that defines a method for registering a consumer.
protocol NetworkConsumerRegisterProtocol {
    func consumerRegister(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel
}

// MARK: - Network Consumer Register Implementation

/// A class that handles the network request for registering a consumer.
final class NetworkConsumerRegister: NetworkConsumerRegisterProtocol {
    
    /// Registers a consumer by sending a POST request with their details.
    /// - Parameters:
    ///   - name: The name of the consumer.
    ///   - email: The email address of the consumer.
    ///   - password: The password chosen by the consumer.
    ///   - role: The role assigned to the consumer (e.g., "consumer").
    /// - Throws: Throws an error if the registration request fails.
    func consumerRegister(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel {
        
        var consumerUser = ConsumerUserModel(email: "", token: "", id: UUID(), role: "", name: "")
        
        // Construct the URL for the consumer registration endpoint
        guard let url = URL(string: "\(ConstantsApp.CONS_API_URL)\(EndPoints.consumerRegister.rawValue)") else {
            throw PKError.badUrl // Throw an error if the URL is invalid
        }
        
        // Create the request body with the consumer details
        let requestBody = ConsumerRegisterRequest(name: name, email: email, password: password, role: role)
        let jsonData = try JSONEncoder().encode(requestBody) // Encode the request body to JSON
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.post // Set the HTTP method to POST
        request.setValue(HttpMethods.content, forHTTPHeaderField: HttpMethods.contentTypeID) // Set the content type
        request.httpBody = jsonData // Set the body of the request with the encoded data
        
        // Send the request and await the response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Ensure the response is a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PKError.errorFromApi(statusCode: -1) // Throw an error if the response is invalid
        }
        // Check the status code of the response
        guard httpResponse.statusCode == HttpResponseCodes.SUCESS else {
            throw PKError.errorFromApi(statusCode: httpResponse.statusCode) // Throw an error if the status code indicates failure
        }
        
        do {

            let result = try JSONDecoder().decode(ConsumerUserModel.self, from: data)
            consumerUser = result
            
        } catch {
            // Handle any errors that occur during the registration process
            print("Error registering Consumer \(error.localizedDescription)")
        }
        
        return consumerUser
    }
}

// MARK: - Mock Implementations

/// A mock implementation for successfully registering a consumer.
final class NetworkConsumerRegisterMock: NetworkConsumerRegisterProtocol {
    func consumerRegister(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel {
        // Simulate successful registration
        return ConsumerUserModel(
            email: email,
            token: "mockToken123",
            id: UUID(),
            role: role,
            name: name
        )
    }
}

/// A mock implementation that simulates a registration failure.
final class NetworkConsumerRegisterFailureMock: NetworkConsumerRegisterProtocol {
    func consumerRegister(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel {
        // Simulate a failure with a specific error code
        throw PKError.errorFromApi(statusCode: 400)
    }
}
