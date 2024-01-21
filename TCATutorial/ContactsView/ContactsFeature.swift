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
        @PresentationState var alert: AlertState<Action.Alert>?         // 削除確認ダイアログ（alert）のState
        var contacts: IdentifiedArrayOf<Contact> = []
    }

    enum Action {
        case addButtonTaped
        case addContact(PresentationAction<AddContactFeature.Action>)   // 連絡先追加画面のAction
        case alert(PresentationAction<Alert>)
        case deleteButtonTapped(id: Contact.ID)

        // アラート上で発生するアクション
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTaped:
                state.addContact = AddContactFeature.State(contact: Contact(id: UUID(), name: ""))  // Addボタンタップ時に連絡先追加画面のStateを作る
                return .none
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
                return .none
            case .addContact:
                return .none
            case let .deleteButtonTapped(id):
                state.alert = AlertState {
                    TextState("Are you sure?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                        TextState("Delete")
                    }
                }
                return .none
                
            case let .alert(.presented(.confirmDeletion(id))):
                state.contacts.remove(id: id)
                return .none
            case .alert:
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {   // ifLetでReducerを統合
            AddContactFeature()
        }
        .ifLet(\.$alert, action: \.alert)               // ifLetでアラートのロジックを統合
    }
}
