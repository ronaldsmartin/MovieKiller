//
//  VideoLibraryReducer.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/27/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift

struct VideoLibraryReducer: Reducer {
    
    func handleAction(action: Action, state: VideoLibraryState?) -> VideoLibraryState {
        guard let state = state else {
            return VideoLibraryState.initialState
        }
        
        switch action {
        default:
            break
        }
        
        return state
    }
}
