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
        return resources.first?.originalFilename ?? "Loading..."
    }
    
    var dateModified: Date? {
        return asset.modificationDate
    }
    
    
    // MARK: - Initializers
    
    init(photosAsset asset: PHAsset) {
        self.asset = asset
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
