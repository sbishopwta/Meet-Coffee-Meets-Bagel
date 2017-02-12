//
//  Theme.swift
//  MeetCMB
//
//  Created by Steven Bishop on 2/5/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

import Foundation
import UIKit

enum Theme {
    
    static func getBarTintColor(for teamMember: TeamMember) -> UIColor {
        if teamMember.id % 2 == 0 {
            return Theme.Colors.coffeeBlue()
        } else {
            return Theme.Colors.coffeePink()
        }
    }

    enum Metrics {
        enum CornerRadius {
            static let imageView: CGFloat = 13.0
        }
        
        enum EdgeInsets {
            static let collectionViewInsets: UIEdgeInsets = UIEdgeInsets(top: 13, left: 3, bottom: 13, right: 3)
        }
    }
    
    enum Colors {
        static func coffeePink() -> UIColor {
            return UIColor(red: 254.0/255.0, green: 0.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        }
        
        static func coffeeBlue() -> UIColor {
            return UIColor(red: 0.0/255.0, green: 129.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        }
        
        static func coffeeGray() -> UIColor {
            return UIColor(red: 230.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        }
    }
}
