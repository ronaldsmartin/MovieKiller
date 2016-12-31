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
    
    private let configReducer = ConfigurationReducer()
    private let libraryReducer = VideoLibraryReducer()
    private let playbackReducer = PlaybackReducer()
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        return AppState(
            configuration: configReducer.handleAction(action: action, state: state?.configuration),
            library: libraryReducer.handleAction(action: action, state: state?.library),
            playback: playbackReducer.handleAction(action: action, state: state?.playback)
        )
    }
}
