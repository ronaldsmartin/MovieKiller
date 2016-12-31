//
//  VideoLibraryViewModel.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/28/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import MediaPlayer
import Photos
import ReSwift
import RxSwift
import RxCocoa

class VideoLibraryViewModel {
    
    let thumbnailManager = PHCachingImageManager.default() as! PHCachingImageManager
    let thumbnailSize = CGSize(width: 79, height: 44)   // 16:9 ratio with standard row height.

    fileprivate let videoResults = Variable<[Video]>(store.state.library.videos)
    fileprivate let videoPlayer = Variable<AVPlayer>(AVPlayer(playerItem: nil))
    
    
    // MARK: - Lifecycle
    
    init() {
        store.subscribe(self) { state in state.library }
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
    // MARK: - Methods
    
    func videos() -> Observable<[Video]> {
        return videoResults.asObservable()
            .do(onNext: { videos in
                let assets = videos.map { $0.asset }
                    .filter { $0 != nil }
                    .map { $0! }
                
                self.thumbnailManager.startCachingImages(for: assets,
                                                         targetSize: self.thumbnailSize,
                                                         contentMode: .aspectFill,
                                                         options: nil)
            })
    }
    
    func onSelect(video: Video) {
        print("Selected video: \(video)")
        store.dispatch(VideoLibraryAction.selectVideo(video: video))
        
        switch video.source {
        case .photos(let asset):
            selectPhotosAsset(asset)
        case .mediaLibrary(let mediaItem):
            selectMediaLibraryAsset(mediaItem)
        }
    }
    
    private func selectPhotosAsset(_ photoAsset: PHAsset) {
        thumbnailManager.requestAVAsset(forVideo: photoAsset, options: nil) { asset, _, info in
            guard let asset = asset else {
                print("Error: Unable to retrieve AVAsset for photos asset \(photoAsset):")
                
                let errorMessage: String
                if let error = info?[PHImageErrorKey] as? Error {
                    print("\(error)")
                    errorMessage = error.localizedDescription
                } else {
                    errorMessage = "An error occurred while trying to play this video. Please try again."
                }
                // TODO: Warn the user the video could not be played.
                
                return
            }
            
            let playerItem = AVPlayerItem(asset: asset)
            self.videoPlayer.value = AVPlayer(playerItem: playerItem)
            // TODO: Dispatch state update to store.
        }
    }
    
    private func selectMediaLibraryAsset(_ mediaItem: MPMediaItem) {
        guard let assetURL = mediaItem.assetURL else {
            print("Error: Unable to retrieve asset URL for media library asset \(mediaItem)")
            // TODO: Warn the user the video could not be played.
            return
        }
        
        let playerItem = AVPlayerItem(url: assetURL)
        self.videoPlayer.value = AVPlayer(playerItem: playerItem)
        // TODO: Dispatch state update to store.
    }
    
    func player() -> SharedSequence<DriverSharingStrategy, AVPlayer> {
        return videoPlayer.asDriver()
    }
    
    func reloadData() {
        store.dispatch(VideoLibraryAction.fetchVideos)
    }
}


// MARK: - StoreSubscriber
extension VideoLibraryViewModel: StoreSubscriber {
    
    func newState(state: VideoLibraryState) {
        videoResults.value = state.videos
    }
}
