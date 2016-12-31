//
//  VideoLibraryReducer.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/27/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import ReSwift
import MediaPlayer
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
    
    private func fetchVideos() -> [Video] {
        var videosFromMediaLib = fetchMoviesFromMediaLibrary()
        let videosFromPhotos = convertToVideos(fetchResult: fetchVideosFromPhotos())
        videosFromMediaLib.append(contentsOf: videosFromPhotos)
        return videosFromMediaLib
    }
    
    private func fetchVideosFromPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false),
            NSSortDescriptor(key: "modificationDate", ascending: false)
        ]
        
        return PHAsset.fetchAssets(with: .video, options: fetchOptions)
    }
    
    func convertToVideos(fetchResult: PHFetchResult<PHAsset>) -> [Video] {
        let assets = (0 ..< fetchResult.count)
            .map(fetchResult.object(at:))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return assets.map { Video(photosAsset: $0, dateFormatter: dateFormatter) }
    }
    
    private func fetchMoviesFromMediaLibrary() -> [Video] {
        let queryPredicate = MPMediaPropertyPredicate(value: MPMediaType.anyVideo.rawValue,
                                                      forProperty: MPMediaItemPropertyMediaType)
        let query = MPMediaQuery(filterPredicates: [queryPredicate])
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let items = query.items ?? []
        return items.map { item in Video(mediaItem: item, dateFormatter: dateFormatter) }
    }
}
