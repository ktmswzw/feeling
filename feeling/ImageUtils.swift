//
//  ImageUtils.swift
//  feeling
//
//  Created by vincent on 15/12/29.
//  Copyright © 2015年 xecoder. All rights reserved.
//

import Foundation
import Photos
import UIKit


func getAssetThumbnail(asset: PHAsset) -> UIImage {
    let manager = PHImageManager.defaultManager()
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
    option.synchronous = true
    manager.requestImageForAsset(asset, targetSize: CGSize(width: 50.0, height: 50.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
        thumbnail = result!
    })
    return thumbnail
}