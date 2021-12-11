//
//  ImageCacheManager.swift
//  LogVieApp
//
//  Created by a0000 on 2021/12/07.
//

import Foundation
import UIKit
class ImageCacheManager{
    static var shared = NSCache<NSString, UIImage>()
}


/*
 이미지를 가져올때
//ImageCacheManager.shared.object(forKey: <#T##NSString#>)
 이미지를 저장할 때
//ImageCacheManager.shared.setObject(blobName,forKey: <#T##NSString#>)
 */
