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

class VideoLibraryViewModel {
    
    let thumbnailManager = PHCachingImageManager.default() as! PHCachingImageManager
    let thumbnailSize = CGSize(width: 79, height: 44)   // 16:9 ratio with standard row height.
    
    private let disposeBag = DisposeBag()
    
    fileprivate var videoResults = Variable<PHFetchResult<PHAsset>>(store.state.library.videos)
    
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
    }
}


// MARK: - StoreSubscriber
extension VideoLibraryViewModel: StoreSubscriber {
    
    func newState(state: VideoLibraryState) {
        videoResults.value = state.videos
    }
}
