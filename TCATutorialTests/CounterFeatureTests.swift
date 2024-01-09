//
//  CounterFeatureTests.swift
//  TCATutorialTests
//
//  Created by Kei on 2023/11/02.
//

import ComposableArchitecture
import XCTest
@testable import TCATutorial

@MainActor
final class CounterFeatureTests: XCTestCase {
    /// Stateの変化に関するテスト
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        // カウンターをインクリメント
        await store.send(.incrementButtonTapped) {
            $0.counter = 1
        }
        // カウンターをデクリメント
        await store.send(.decrementButtonTapped) {
            $0.counter = 0
        }
    }

    /// Effectに関するテスト
    func testTimer() async {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        // タイマースタート
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        // 1秒時間を進める
        await clock.advance(by: .seconds(1))
        // カウントアップActionを受け取る
        await store.receive(\.timerTick) {
            $0.counter = 1
        }
        // タイマーストップ
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    /// ネットワークリクエストに関するテスト
    func testNumberFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            // 依存関係をオーバーライド
            // レスポンスの値を定義してんじゃん
            $0.numberFact.fetch = { "\($0) is a good number." }
        }

        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }
}
