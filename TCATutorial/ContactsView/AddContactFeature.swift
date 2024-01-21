//
//  AddContactFeature.swift
//  TCATutorial
//
//  Created by Kei on 2024/01/21.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddContactFeature {
    struct State: Equatable {
        var contact: Contact
    }

    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setName(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .none
                
            case .saveButtonTapped:
                return .none
                
            case let .setName(name):
                state.contact.name = name
                return .none
            }
        }
    }
}
