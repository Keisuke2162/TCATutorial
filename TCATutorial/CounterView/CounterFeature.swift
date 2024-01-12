//
//  CounterFeature.swift
//  TCATutorial
//
//  Created by Kei on 2023/10/11.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct CounterFeature: Reducer {
    struct State: Equatable {
        var counter: Int = 0
        var fact: String?
        var isLoading: Bool = false
        var isTimerRunning = false
    }

    @CasePathable
    enum Action {
        case decrementButtonTapped                  // カウンターをマイナス
        case incrementButtonTapped                  // カウンターをプラス
        case factButtonTapped                       // 数値の概要をAPIから取得
        case factResponse(String)    // APIの結果をfactに反映する
        case toggleTimerButtonTapped                // タイマーのスタート・ストップ
        case timerTick                              // タイマー動作時にカウンターをプラスする
    }
    
    enum CancelID {
        case timer
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.counter -= 1
                state.fact = nil
                return .none
                
            case .incrementButtonTapped:
                state.counter +=  1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.counter] send in
                    try await send(.factResponse(self.numberFact.fetch(count)))
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                    
                }
            case .timerTick:
                state.counter += 1
                state.fact = nil
                return .none
            }
        }
    }
}
