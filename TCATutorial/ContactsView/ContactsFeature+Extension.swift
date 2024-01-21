//
//  ContactsFeature+Extension.swift
//  TCATutorial
//
//  Created by Kei on 2024/01/21.
//

import Foundation
import ComposableArchitecture

extension ContactsFeature {
    @Reducer
    struct Destination {
        enum State: Equatable {
            case addContact(AddContactFeature.State)
            case alert(AlertState<ContactsFeature.Action.Alert>)
        }
        enum Action {
            case addContact(AddContactFeature.Action)
            case alert(ContactsFeature.Action.Alert)
        }
        var body: some ReducerOf<Self> {
            Scope(state: \.addContact, action: \.addContact) {
                AddContactFeature()
            }
        }
    }
}
