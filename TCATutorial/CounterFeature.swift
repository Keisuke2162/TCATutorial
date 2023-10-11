//
//  CounterFeature.swift
//  TCATutorial
//
//  Created by Kei on 2023/10/11.
//

import ComposableArchitecture

struct CounterFeature: Reducer {
    struct State {
        var counter = 0
    }

    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.counter -= 1
            return .none
        case .incrementButtonTapped:
            state.counter +=  1
            return .none
        }
    }
}

extension CounterFeature.State: Equatable {}
