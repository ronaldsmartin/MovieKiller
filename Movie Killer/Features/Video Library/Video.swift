//
//  Video.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/28/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import Foundation
import Photos
import RxSwift

struct Video {
    
    let asset: PHAsset
    
    let thumbnail = Variable<UIImage?>(nil)
    
    var filename: String {
        let resources = PHAssetResource.assetResources(for: asset)
        return resources.first?.originalFilename ?? "Unnamed movie file"
    }
    
    let displayDate: String
    
    
    // MARK: - Initializers
    
    init(photosAsset asset: PHAsset, dateFormatter formatter: DateFormatter) {
        self.asset = asset
        
        let videoDate = asset.modificationDate ?? asset.creationDate
        if let videoDate = videoDate {
            self.displayDate = formatter.string(from: videoDate)
        } else {
            self.displayDate = ""
        }
    }
    
    func getThumbnail(with imageManager: PHImageManager, size: CGSize) {
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

// MARK: - Equatable
extension Video: Equatable {}
func ==(lhs: Video, rhs: Video) -> Bool {
    return lhs.asset.isEqual(rhs.asset)
        || lhs.filename == rhs.filename
}
