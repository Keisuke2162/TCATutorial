//
//  NumberFactClient.swift
//  TCATutorial
//
//  Created by Kei on 2024/01/10.
//

import ComposableArchitecture
import Foundation

struct NumberFactClient {
    var fetch: @Sendable (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
    static var liveValue = Self(
        fetch: { count in
            try await Task.sleep(for: .seconds(1))
            let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(count)")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
