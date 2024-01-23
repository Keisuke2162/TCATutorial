//
//  ContactsFeatureTests.swift
//  TCATutorialTests
//
//  Created by Kei on 2024/01/22.
//

import ComposableArchitecture
import XCTest
@testable import TCATutorial

@MainActor
final class ContactsFeatureTests: XCTestCase {
    /// Test Section1
    func testAddFlow() async {
        // Featureの初期状態、テスト対象のReducerでstoreを構築
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        // Addボタンタップ時に連絡先追加画面が生成されること
        await store.send(.addButtonTaped) {
            $0.destination = .addContact(AddContactFeature.State(contact: .init(id: UUID(0), name: "")))
        }
        
        // 連絡先追加画面で名前入力時にStateに反映されていること
        await store.send(.destination(.presented(.addContact(.setName("Kei"))))) {
            $0.$destination[case: \.addContact]?.contact.name = "Kei"
        }
        
        // 連絡先追加画面でSaveボタンを押した場合
        // すぐにStateが変更されないのでクロージャは使わなず store.receiveでStateの値を監視する
        await store.send(.destination(.presented(.addContact(.saveButtonTapped))))
        await store.receive(
            \.destination.addContact.delegate.saveContact,
             Contact(id: UUID(0), name: "Kei")
        ) {
            $0.contacts = [Contact(id: UUID(0), name: "Kei")]
        }
        
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
    
    
    /// Test Section2
    func testAddFlow_NonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off
        
        await store.send(.addButtonTaped)
        await store.send(.destination(.presented(.addContact(.setName("San")))))
        await store.send(.destination(.presented(.addContact(.saveButtonTapped))))
        await store.skipReceivedActions()
        
        store.assert { state in
            state.contacts = [Contact(id: UUID(0), name: "San")]
            state.destination = nil
        }
    }
}
