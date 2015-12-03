//
//  UIBeans.swift
//  feeling
//
//  Created by vincent on 15/11/22.
//  Copyright © 2015年 xecoder. All rights reserved.
//

import Foundation
import MaterialKit
import ActionButton

func initButton(initButton: MKButton){
    initButton.cornerRadius = 30.0
    initButton.backgroundLayerCornerRadius = 30.0
    initButton.maskEnabled = false
    initButton.ripplePercent = 1.75
    initButton.rippleLocation = .Center
    
    initButton.layer.shadowOpacity = 0.75
    initButton.layer.shadowRadius = 3.5
    initButton.layer.shadowColor = UIColor.blackColor().CGColor
    initButton.layer.shadowOffset = CGSize(width: 1.0, height: 2.5)
}

func initButton(initButton: MKButton, initRadius: CGFloat){
    initButton.cornerRadius = initRadius
    initButton.backgroundLayerCornerRadius = 30.0
    initButton.maskEnabled = false
    initButton.ripplePercent = 1.75
    initButton.rippleLocation = .Center

    initButton.layer.shadowOpacity = 0.75
    initButton.layer.shadowRadius = 3.5
    initButton.layer.shadowColor = UIColor.blackColor().CGColor
    initButton.layer.shadowOffset = CGSize(width: 1.0, height: 2.5)
}


func initText(initText: MKTextField,initTitle: String)
{
    // No border, shadow, floatingPlaceholderEnabled
    initText.layer.borderColor = UIColor.clearColor().CGColor
    initText.floatingPlaceholderEnabled = true
    initText.placeholder = initTitle
    initText.rippleLayerColor = UIColor.MKColor.LightBlue
    initText.tintColor = UIColor.MKColor.Blue
    initText.backgroundColor = UIColor(hex: 0xE0E0E0)
}

func initImage(initImage: MKImageView)
{       
    initImage.layer.borderColor = UIColor.MKColor.DeepPurple.CGColor
    initImage.layer.borderWidth = 0.0
    initImage.cornerRadius = 10
    initImage.rippleLocation = .TapLocation
    initImage.backgroundAniEnabled = true
}
