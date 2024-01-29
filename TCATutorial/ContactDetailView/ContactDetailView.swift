//
//  ContactDetailView.swift
//  TCATutorial
//
//  Created by Kei on 2024/01/30.
//

import ComposableArchitecture
import SwiftUI

struct ContactDetailView: View {
    let store: StoreOf<ContactDetailFeature>

    var body: some View {
        Form {
            Text("A")
        }
        .navigationTitle(store.contact.name)
    }
}

#Preview {
    NavigationStack {
        ContactDetailView(store: .init(initialState: ContactDetailFeature.State(contact: .init(id: UUID(), name: "Bob")),
                                       reducer: {
            ContactDetailFeature()
        }))
    }
}
