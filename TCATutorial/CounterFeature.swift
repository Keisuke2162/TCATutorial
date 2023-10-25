//
//  CounterFeature.swift
//  TCATutorial
//
//  Created by Kei on 2023/10/11.
//

import ComposableArchitecture
import Foundation

struct CounterFeature: Reducer {
    struct State {
        var counter: Int = 0
        var fact: String?
        var isLoading: Bool = false
    }

    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.counter -= 1
            state.fact = nil
            return .none

        case .incrementButtonTapped:
            state.counter +=  1
            state.fact = nil
            return .none

        case .factButtonTapped:
            state.fact = nil
            state.isLoading = true
            return .run { [count = state.counter] send in
                let (data, _) = try await URLSession.shared
                    .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                let fact = String(decoding: data, as: UTF8.self)
            }
        }
    }
}

extension CounterFeature.State: Equatable {}
