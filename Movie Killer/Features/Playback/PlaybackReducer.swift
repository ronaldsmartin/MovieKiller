//
//  PlaybackReducer.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/30/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift

struct PlaybackReducer: Reducer {
    
    func handleAction(action: Action, state: PlaybackState?) -> PlaybackState {
        guard let state = state else {
            return PlaybackState()
        }
        guard let action = action as? PlaybackAction else {
            // Ignore actions that don't apply to this module.
            return state
        }
        
        switch action {
        case .startPlayback:
            break
        case .pausePlayback:
            break
        case .stopPlayback:
            break
        }
        
        return state
    }
}
