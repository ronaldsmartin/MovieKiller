//
//  AppReducer.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/27/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        return AppState(
            configuration: ConfigurationReducer()
                .handleAction(action: action, state: state?.configuration)
        )
    }
}
