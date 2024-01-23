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
        var contacts: IdentifiedArrayOf<Contact> = []
        @PresentationState var destination: Destination.State?
    }

    @CasePathable
    enum Action {
        case addButtonTaped
        case deleteButtonTapped(id: Contact.ID)
        case destination(PresentationAction<Destination.Action>)
        // アラート上で発生するアクション
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTaped:
                state.destination = .addContact(AddContactFeature.State(contact: Contact(id: self.uuid(), name: "")))    //　連絡先追加ViewのReducerを向いたDestination
                return .none
            
            // 連絡先追加画面のSaveボタンタップ
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none
            // 削除確認アラートの「削除」ボタンタップ
            case let .destination(.presented(.alert(.confirmDeletion(id)))):
                state.contacts.remove(id: id)
                return .none
            case .destination:
                return .none

            case let .deleteButtonTapped(id):
                state.destination = .alert(.deleteConfirmation(id: id))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {   // ifLetでReducerを統合
            Destination()
        }
    }
}

extension AlertState where Action == ContactsFeature.Action.Alert {
    static func deleteConfirmation(id: UUID) -> Self {
        Self {
            TextState("Are you sure?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                TextState("Delete")
            }
        }
    }
}
