//
//  VideoLibraryViewModel.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/28/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import Photos
import ReSwift
import RxSwift
import RxCocoa

class VideoLibraryViewModel {
    
    let thumbnailManager = PHCachingImageManager.default() as! PHCachingImageManager
    let thumbnailSize = CGSize(width: 79, height: 44)   // 16:9 ratio with standard row height.

    fileprivate let videoResults = Variable<PHFetchResult<PHAsset>>(store.state.library.videos)
    fileprivate let videoPlayer = Variable<AVPlayer>(AVPlayer(playerItem: nil))
    
    
    // MARK: - Lifecycle
    
    init() {
        store.subscribe(self) { state in state.library }
        store.dispatch(VideoLibraryAction.fetchVideos)
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
    // MARK: - Methods
    
    func videos() -> Observable<[Video]> {
        return videoResults.asObservable()
            .map { fetchResult in
                let assets = (0 ..< fetchResult.count)
                    .map(fetchResult.object(at:))
                
                self.thumbnailManager.startCachingImages(for: assets,
                                                         targetSize: self.thumbnailSize,
                                                         contentMode: .aspectFill,
                                                         options: nil)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none
                
                return assets.map { Video(photosAsset: $0, dateFormatter: dateFormatter) }
            }
    }
    
    func onSelect(video: Video) {
        print("Selected video: \(video)")
        store.dispatch(VideoLibraryAction.selectVideo(video: video))
        
        thumbnailManager.requestAVAsset(forVideo: video.asset, options: nil) { asset, _, info in
            guard let asset = asset else {
                print("Error: Unable to retrieve AVAsset for photos asset \(video.asset):")
                
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
