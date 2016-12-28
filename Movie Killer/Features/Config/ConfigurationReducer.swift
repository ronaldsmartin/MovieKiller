//
//  ConfigurationReducer.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/27/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift

struct ConfigurationReducer: Reducer {
    
    func handleAction(action: Action, state: ConfigurationState?) -> ConfigurationState {
        guard let state = state else {
            return ConfigurationState.initialState
        }
        
        switch action {
        default:
            break
        }
        
        return state
    }
}
