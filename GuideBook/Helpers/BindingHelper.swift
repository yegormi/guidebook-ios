//
//  BindingHelper.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import SwiftUI

extension Binding where Value: Equatable {
    func removeDuplicates() -> Self {
        .init(
            get: { self.wrappedValue },
            set: { newValue, transaction in
                guard newValue != self.wrappedValue else { return }
                self.transaction(transaction).wrappedValue = newValue
            }
        )
    }
}
