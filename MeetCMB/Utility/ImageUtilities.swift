//
//  ImageUtilities.swift
//  MeetCMB
//
//  Created by Steven Bishop on 2/5/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

import Foundation
import UIKit

class ImageUtilities {
    static func getPlaceholderImage(for id: Int) -> UIImage {
        if id % 2 == 0 {
            return #imageLiteral(resourceName: "Place_Holder_Bagel")
        } else {
            return #imageLiteral(resourceName: "Placeholder_Coffee")
        }
    }
    
    static func getMoreButton(for id: Int) -> UIImage {
        if id % 2 == 0 {
            return #imageLiteral(resourceName: "More_Button_Blue")
        } else {
            return #imageLiteral(resourceName: "More_Button_Pink")
        }
    }
}
