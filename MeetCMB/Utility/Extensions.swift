//
//  Extensions.swift
//  MeetCMB
//
//  Created by Steven Bishop on 2/5/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

import Foundation
import UIKit

//TODO: Move this. Temporarily global
//Setting kCIContextWorkingColorSpace to Null increases performance. Thumbnail sizes are too small to notice color management.
let sharedCIContext = CIContext(options: [kCIContextWorkingColorSpace : NSNull()])

extension UIImage {
    func applyFilter(context: CIContext = sharedCIContext, closure: (CIImage) -> CIImage?) -> UIImage? {
        
        func inputImageForImage(image: Image) -> CIImage? {
            if let image = image.cgImage {
                return CIImage(cgImage: image)
            }
            if let image = image.ciImage {
                return image
            }
            return nil
        }
        
        guard let inputImage = inputImageForImage(image: self), let outputImage = closure(inputImage) else {
            return nil
        }
        
        guard let imageRef = context.createCGImage(outputImage, from: inputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
    
    func applyFilter(filter: CIFilter?, context: CIContext = sharedCIContext) -> UIImage? {
        guard let filter = filter else {
            return nil
        }
        
        return applyFilter(context: context) {
            filter.setValue($0, forKey: kCIInputImageKey)
            return filter.outputImage
        }
    }
}

extension UICollectionViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UIFont {
    class func primaryFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "SourceSansPro-Regular", size: size)!
    }
    
    class func semiBoldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "SourceSansPro-Semibold", size: size)!
    }
    
    class func lightFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "SourceSansPro-Light", size: size)!
    }
}
