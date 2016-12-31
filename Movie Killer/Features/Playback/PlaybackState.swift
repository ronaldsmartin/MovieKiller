//
//  PlaybackState.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/30/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import AVFoundation
import ReSwift

/**
 Sub-state for video playback.
 */
struct PlaybackState: StateType {
    
    static let defaultPlaybackTime: TimeInterval = 60
    
    var timeUntilCrash: TimeInterval = defaultPlaybackTime
}
