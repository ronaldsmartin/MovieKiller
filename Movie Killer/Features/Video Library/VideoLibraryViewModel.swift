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

class VideoLibraryViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    fileprivate var videoResults = Variable<PHFetchResult<PHAsset>>(store.state.library.videos)
    
    override init() {
        super.init()
        store.subscribe(self) { state in state.library }
        store.dispatch(VideoLibraryAction.fetchVideos)
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
    func videos() -> Observable<[PHAsset]> {
        // TODO: Replace PHAsset with a ViewModel type.
        return videoResults.asObservable()
            .map { fetchResult in
                (0 ..< fetchResult.count).map { fetchResult.object(at: $0) }
            }
    }
}


// MARK: - StoreSubscriber
extension VideoLibraryViewModel: StoreSubscriber {
    
    func newState(state: VideoLibraryState) {
        videoResults.value = state.videos
    }
}
