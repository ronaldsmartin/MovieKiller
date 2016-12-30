//
//  VideoLibraryState.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/27/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift
import Photos

/*
 Application sub-state containing info related to fetching, displaying, and selecting videos.
 */
struct VideoLibraryState: StateType {
    
    static var initialState: VideoLibraryState {
        return VideoLibraryState()
    }
    
    /// The collection of movies with which the user can interact view and play.
    var videos = PHFetchResult<PHAsset>()
    
    var selectedVideo: Video?
}
