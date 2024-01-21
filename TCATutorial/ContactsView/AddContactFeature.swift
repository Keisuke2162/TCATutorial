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
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)
        
        enum Delegate: Equatable {
//            case cancel
            case saveContact(Contact)
        }
    }
    @Dependency(\.dismiss) var dismiss  // 自分自身でdismissできるように

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
//                return .send(.delegate(.cancel))
            case .delegate:
                return .none
            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await dismiss()
                }
//                return .send(.delegate(.saveContact(state.contact)))
            case let .setName(name):
                state.contact.name = name
                return .none
            }
        }
    }
}
