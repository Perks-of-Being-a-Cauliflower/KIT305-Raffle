//
//  UITabBarController.swift
//  Tutorial5
//
//  Created by Liam kenna on 26/4/20.
//  Copyright © 2020 Liam Kenna. All rights reserved.
//

import Foundation
import UIKit

class UITabBarController : UIViewController{
    

}

class CustomUITabBar : UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 71
        return sizeThatFits
    }
}
