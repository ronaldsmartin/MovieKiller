//
//  PlaybackReducer.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/30/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import AVFoundation
import ReSwift

struct PlaybackReducer: Reducer {
    
    func handleAction(action: Action, state: PlaybackState?) -> PlaybackState {
        guard var state = state else {
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
            // Reset the crash counter.
            // TODO: Pull value from user settings.
            state.timeUntilCrash = PlaybackState.defaultPlaybackTime
        case .playbackElapsed(let elapsedTime):
            state.timeUntilCrash -= elapsedTime
        case .crashPlayback:
            fatalError("Haha time to crash!")
        }
        
        return state
    }
}
