//
//  ContactDetailFeature.swift
//  TCATutorial
//
//  Created by Kei on 2024/01/30.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ContactDetailFeature {
    @ObservableState
    struct State: Equatable {
        let contact: Contact
    }
    enum Action {
        
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
