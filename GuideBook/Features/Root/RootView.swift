////
////  RootView.swift
////  GuideBook
////
////  Created by Yegor Myropoltsev on 05.11.2023.
////
//
//import SwiftUI
//import ComposableArchitecture
//
//struct RootView: View {
//    let store: StoreOf<RootFeature>
//    
//    var body: some View {
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
//            
//        }
//    }
//}
//
//
//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView(
//            store: Store(initialState: RootFeature.State()) {
//                RootFeature()
//                    ._printChanges()
//            }
//        )
//    }
//}
