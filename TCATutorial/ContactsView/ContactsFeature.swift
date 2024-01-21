//
//  ContactsFeature.swift
//  TCATutorial
//
//  Created by Kei on 2024/01/13.
//

import Foundation
import ComposableArchitecture

// Entity
struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

// Reducer
@Reducer
struct ContactsFeature {
    struct State: Equatable {
        @PresentationState var addContact: AddContactFeature.State?     // 連絡先追加画面のState
        var contacts: IdentifiedArrayOf<Contact> = []
    }

    enum Action {
        case addButtonTaped
        case addContact(PresentationAction<AddContactFeature.Action>)   // 連絡先追加画面のAction
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTaped:
                state.addContact = AddContactFeature.State(contact: Contact(id: UUID(), name: ""))  // Addボタンタップ時に連絡先追加画面のStateを作る
                return .none
            case .addContact(.presented(.cancelButtonTapped)):
                state.addContact = nil                                  // 連絡先追加画面でキャンセルした時はaddContactStateをnil
                return .none
            case .addContact(.presented(.saveButtonTapped)):
                guard let contact = state.addContact?.contact else { return .none }
                state.contacts.append(contact)
                state.addContact = nil
                return .none
            case .addContact:
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {                   // ifLetでReducerを統合
            AddContactFeature()
        }
    }
}
