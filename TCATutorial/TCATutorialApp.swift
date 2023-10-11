//
//  TCATutorialApp.swift
//  TCATutorial
//
//  Created by Kei on 2023/10/11.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCATutorialApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            CounterView(store: TCATutorialApp.store)
        }
    }
}
