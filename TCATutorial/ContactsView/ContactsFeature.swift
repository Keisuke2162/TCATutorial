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

    struct State {
        var contacts: IdentifiedArrayOf<Contact> = []
    }

    enum Action {
        case addButtonTaped
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
        }
    }
}
