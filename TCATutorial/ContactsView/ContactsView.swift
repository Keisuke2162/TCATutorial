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
                        HStack {
                            Text(contact.name)
                            Spacer()
                            Button {
                                viewStore.send(.deleteButtonTapped(id: contact.id))
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(
                                        Color.red
                                    )
                            }

                        }
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
        .sheet(store: self.store.scope(state: \.$addContact, action: \.addContact)) { store in
            NavigationStack {
                AddContactView(store: store)
            }
        }
        .alert(store: self.store.scope(state: \.$alert, action: \.alert))
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
