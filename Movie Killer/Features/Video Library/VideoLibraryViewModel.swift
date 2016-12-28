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
}


// MARK: - StoreSubscriber
extension VideoLibraryViewModel: StoreSubscriber {
    
    func newState(state: VideoLibraryState) {
        videoResults.value = state.videos
    }
}


// MARK: - UITableViewDataSource
extension VideoLibraryViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoResults.value.count
    }
    
    private static let CellReuseId = "VideoLibraryCell"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoLibraryViewModel.CellReuseId,
                                                 for: indexPath)
        
        return cell
    }
}
