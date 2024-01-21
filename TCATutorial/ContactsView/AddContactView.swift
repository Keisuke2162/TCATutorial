//
//  AddContactView.swift
//  TCATutorial
//
//  Created by Kei on 2024/01/21.
//

import SwiftUI
import ComposableArchitecture

struct AddContactView: View {
    let store: StoreOf<AddContactFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                TextField("Name", text: viewStore.binding(get: \.contact.name, send: { .setName($0) }))
                Button("Save") {
                    viewStore.send(.saveButtonTapped)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        viewStore.send(.cancelButtonTapped)
                    }
                }
            }
        }
    }
}

#Preview {
    AddContactView(
        store: Store(
            initialState: AddContactFeature.State(contact: .init(id: UUID(), name: "Sample")),
            reducer: {
                AddContactFeature()
            }
        )
    )
}
