//
//  CounterView.swift
//  TCATutorial
//
//  Created by Kei on 2023/10/12.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("\(viewStore.counter.description)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                HStack {
                    Button("-") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    Button("+") {
                        viewStore.send(.incrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                }
                Button("Fact") {
                    viewStore.send(.factButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)

                if viewStore.isLoading {
                    ProgressView()
                } else if let fact = viewStore.fact {
                    Text(fact)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Button(viewStore.isTimerRunning ? "Stop Timer" : "Start Timer") {
                    viewStore.send(.toggleTimerButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(
            store: Store(initialState: CounterFeature.State(), reducer: {
                CounterFeature()
            })
        )
    }
}

