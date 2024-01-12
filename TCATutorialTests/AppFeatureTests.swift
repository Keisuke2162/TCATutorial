//
//  AppFeatureTests.swift
//  TCATutorialTests
//
//  Created by Kei on 2024/01/12.
//

import ComposableArchitecture
import XCTest
@testable import TCATutorial

@MainActor
final class AppFeatureTests: XCTestCase {
    func testIncrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.tab1(.incrementButtonTapped)) {
            $0.tab1.counter = 1
        }
    }
}
