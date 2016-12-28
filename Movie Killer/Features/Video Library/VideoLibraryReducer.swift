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
            return state
        case .selectVideo(_):
            break
        }
        
        return state
    }
    
    private func fetchVideos() -> PHFetchResult<PHAsset> {
        let videoCollections = PHAssetCollection
            .fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: nil)
        
        if let videos = videoCollections.firstObject {
            return PHAsset.fetchAssets(in: videos, options: nil)
        }
        return PHFetchResult<PHAsset>()
    }
}
