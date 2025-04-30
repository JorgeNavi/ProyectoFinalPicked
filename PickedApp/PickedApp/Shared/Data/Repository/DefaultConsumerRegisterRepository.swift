//
//  DefaultConsumerRegisterRepository.swift
//  PickedApp
//
//  Created by Kevin Heredia on 15/4/25.
//

import Foundation

final class DefaultConsumerRegisterRepository: ConsumerRegisterRepositoryProtocol {
    private var network: NetworkConsumerRegisterProtocol
    
    init(network: NetworkConsumerRegisterProtocol = NetworkConsumerRegister()) {
        self.network = network
    }
    
    func consumerRegister(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel{
       
            try await network.consumerRegister(name: name, email: email, password: password, role: role)
          
    }
}

final class DefaultConsumerRegisterRepositoryMock: ConsumerRegisterRepositoryProtocol {
    private var network: NetworkConsumerRegisterProtocol
    
    init(network: NetworkConsumerRegisterProtocol = NetworkConsumerRegisterMock()) {
        self.network = network
    }
    
    func consumerRegister(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel{
            try await network.consumerRegister(name: name, email: email, password: password, role: role)
    }
}

final class DefaultConsumerRegisterRepositoryFailureMock: ConsumerRegisterRepositoryProtocol {
    private var network: NetworkConsumerRegisterProtocol
    
    init(network: NetworkConsumerRegisterProtocol = NetworkConsumerRegisterMock()) {
        self.network = network
    }
    
    func consumerRegister(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel{
        throw PKError.errorFromApi(statusCode: 400)
    }
}
