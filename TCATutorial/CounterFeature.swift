//
//  CounterFeature.swift
//  TCATutorial
//
//  Created by Kei on 2023/10/11.
//

import ComposableArchitecture
import Foundation

struct CounterFeature: Reducer {
    struct State {
        var counter: Int = 0
        var fact: String?
        var isLoading: Bool = false
        var isTimerRunning = false
    }

    enum Action {
        case decrementButtonTapped      // カウンターをマイナス
        case incrementButtonTapped      // カウンターをプラス
        case factButtonTapped           // 数値の概要をAPIから取得
        case factResponse(String)       // APIの結果をfactに反映する
        case toggleTimerButtonTapped    // タイマーのスタート・ストップ
        case timerTick                  // タイマー動作時にカウンターをプラスする
    }
    
    enum CancelID {
        case timer
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
                let (data, _) = try await URLSession.shared
                    .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                let fact = String(decoding: data, as: UTF8.self)
                await send(.factResponse(fact))
            }
        case let .factResponse(fact):
            state.fact = fact
            state.isLoading = false
            return .none
        case .toggleTimerButtonTapped:
            state.isTimerRunning.toggle()
            if state.isTimerRunning {
                return .run { send in
                    while true {
                        try await Task.sleep(for: .seconds(1))
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

extension CounterFeature.State: Equatable {}
