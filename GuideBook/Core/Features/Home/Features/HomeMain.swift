//
//  HomeMain.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct HomeMainView: View {
    let store: StoreOf<HomeMain>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Hello World!!!")
        }
    }
}

struct HomeMain: Reducer {
    struct State: Equatable {

    }
    
    enum Action: Equatable {
        
    }
    
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}
