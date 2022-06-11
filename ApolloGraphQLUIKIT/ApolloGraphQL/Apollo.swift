//
//  Apollo.swift
//  ApolloGraphQLUIKIT
//
//  Created by Mariano Battaglia on 07/05/22.
//

import Foundation
import Apollo

class Network {
    static let shared = Network()
    lazy var apollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)
}
