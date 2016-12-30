//
//  VideoLibraryReducer.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/27/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift
import Photos

struct VideoLibraryReducer: Reducer {
    
    func handleAction(action: Action, state: VideoLibraryState?) -> VideoLibraryState {
        guard var state = state else {
            return VideoLibraryState.initialState
        }
        guard let action = action as? VideoLibraryAction else {
            // Ignore actions that don't apply to this module.
            return state
        }
        
        switch action {
        case .fetchVideos:
            state.videos = fetchVideos()
        case .selectVideo(let video):
            state.selectedVideo = video
        }
        
        return state
    }
    
    private func fetchVideos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false),
            NSSortDescriptor(key: "modificationDate", ascending: false)
        ]
        
        return PHAsset.fetchAssets(with: .video, options: fetchOptions)
    }
}
