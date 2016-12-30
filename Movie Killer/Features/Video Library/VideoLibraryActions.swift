//
//  VideoLibraryActions.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/27/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift


enum VideoLibraryAction: Action {
    /// Query the Photos framework for videos stored on the device.
    case fetchVideos
    /// Select a specific video from the library for playback.
    case selectVideo(video: Video)
}
