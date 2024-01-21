//
//  AppView.swift
//  TCATutorial
//
//  Created by Kei on 2024/01/12.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        TabView {
            CounterView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem { Text("A") }
            CounterView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem { Text("B") }
        }
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State(), reducer: {
            AppFeature()
        })
    )
}
