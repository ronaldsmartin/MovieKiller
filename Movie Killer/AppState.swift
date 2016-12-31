//
//  AppState.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/27/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift

/// The global application state.
struct AppState: StateType {
    
    /// User application settings.
    let configuration: ConfigurationState
    
    /// Movies playable through the app.
    let library: VideoLibraryState
    
    /// Sub-state of the currently playing video.
    let playback: PlaybackState
}
