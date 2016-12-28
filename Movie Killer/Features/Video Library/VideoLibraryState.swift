//
//  VideoLibraryState.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/27/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift

/*
 Application sub-state containing info related to fetching, displaying, and selecting videos.
 */
struct VideoLibraryState: StateType {
    
    static var initialState: VideoLibraryState {
        return VideoLibraryState()
    }
    
    /// Whether or not the user has granted the app permission to access Photos/Videos.
    var hasPhotosPermission = false
    
    /// The collection of movies that
    var library = [Any]()
}
