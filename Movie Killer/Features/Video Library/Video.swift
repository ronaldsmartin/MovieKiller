//
//  Video.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/28/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import MediaPlayer
import Photos
import RxSwift

struct Video {
    
    enum Source {
        case mediaLibrary(MPMediaItem)
        case photos(PHAsset)
    }
    
    // MARK: Stored properties
    
    let source: Source
    
    let thumbnail = Variable<UIImage?>(nil)
    
    let displayDate: String
    
    // MARK: Computed properties
    
    var name: String {
        switch source {
        case .mediaLibrary(let mediaItem):
            return mediaItem.title ?? "Unnamed movie file"
        case .photos(let asset):
            let resources = PHAssetResource.assetResources(for: asset)
            return resources.first?.originalFilename ?? "Unnamed video file"
        }
    }
    
    var asset: PHAsset? {
        if case .photos(let asset) = source {
            return asset
        }
        return nil
    }
    
    var mediaItem: MPMediaItem? {
        if case .mediaLibrary(let item) = source {
            return item
        }
        return nil
    }
    
    var duration: TimeInterval {
        switch source {
        case .mediaLibrary(let item):
            return item.playbackDuration
        case .photos(let asset):
            return asset.duration
        }
    }
    
    
    // MARK: - Initializers
    
    init(photosAsset asset: PHAsset, dateFormatter formatter: DateFormatter) {
        self.source = .photos(asset)
        
        let videoDate = asset.modificationDate ?? asset.creationDate
        if let videoDate = videoDate {
            self.displayDate = formatter.string(from: videoDate)
        } else {
            self.displayDate = ""
        }
    }
    
    init(mediaItem item: MPMediaItem,
         dateFormatter formatter: DateFormatter) {
        self.source = .mediaLibrary(item)
        
        if let videoDate = item.releaseDate {
            self.displayDate = formatter.string(from: videoDate)
        } else if #available(iOS 10.0, *) {
            self.displayDate = formatter.string(from: item.dateAdded)
        } else {
            self.displayDate = ""
        }
    }
    
    func getThumbnail(with imageManager: PHImageManager, size: CGSize) {
        switch source {
        case .mediaLibrary(let mediaItem):
            self.thumbnail.value = mediaItem.artwork?.image(at: size)
        case .photos(let asset):
            imageManager.requestImage(for: asset,
                                      targetSize: size,
                                      contentMode: .aspectFill,
                                      options: nil) { result, info in
                DispatchQueue.main.async {
                    self.thumbnail.value = result
                }
            }
        }
    }
}

// MARK: - Equatable
extension Video: Equatable {}
func ==(lhs: Video, rhs: Video) -> Bool {
    switch (lhs.source, rhs.source) {
    case (.photos(let lhsAsset), .photos(let rhsAsset)):
        return lhsAsset.isEqual(rhsAsset)
            || lhs.name == rhs.name
    case (.mediaLibrary(let lhsMediaItem), .mediaLibrary(let rhsMediaItem)):
        return lhsMediaItem.isEqual(rhsMediaItem)
    default:
        return false
    }
}
