//
//  ContactsView.swift
//  TCATutorial
//
//  Created by Kei on 2024/01/21.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    let store: StoreOf<ContactsFeature>

    var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                List {
                    ForEach(viewStore.state.contacts) { contact in
                        Text(contact.name)
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTaped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContactsView(
        store: Store(
            initialState: ContactsFeature.State(
                contacts: [
                    .init(id: UUID(), name: "AAA"),
                    .init(id: UUID(), name: "BBB"),
                    .init(id: UUID(), name: "CCC")
                ]
            ),
            reducer: {
                ContactsFeature()
            }
        )
    )
}
