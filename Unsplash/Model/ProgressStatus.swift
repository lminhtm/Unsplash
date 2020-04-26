//
//  ProgressStatus.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation

enum ProgressStatusState {
    case unknowned
    case loading
    case success
    case successWithNoData
    case failure(Error)
}

struct ProgressStatus {
    
    var state: ProgressStatusState = .unknowned
    
    lazy var message: String = {
        switch state {
        case .loading:
            return "Loading data..."
        case .success:
            return "Loading data..."
        case .successWithNoData:
            return "No data"
        case .failure (let error):
            return error.localizedDescription
        default:
            return ""
        }
    }()
    
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
}
