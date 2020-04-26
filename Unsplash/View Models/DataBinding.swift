//
//  DataBinding.swift
//  MVVM
//
//  Created by LMinh on 3/27/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation

class DataBinding<T> {
    
    typealias Handler = (T) -> Void
    private var handlers: [Handler] = []
    
    var value: T {
        didSet {
            fire()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ handler: @escaping Handler) {
        handlers.append(handler)
    }
    
    func bindAndFire(_ handler: @escaping Handler) {
        bind(handler)
        fire()
    }
    
    private func fire() {
        for handler in handlers {
            handler(value)
        }
    }
}

