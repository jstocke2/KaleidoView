//
//  KaleidoVieww.swift
//  KaleidoView
//
//  Created by Jake Stocker on 3/3/16.
//  Copyright © 2016 Jake Stocker. All rights reserved.
//

import UIKit

class KaleidoVieww: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // Rectangle
    var rectWidth     : CGFloat =  20.0
    var rectHeight    : CGFloat =  30.0
    var rectWidthMin  : CGFloat =  10.0
    var rectWidthMax  : CGFloat = 120.0
    var rectHeightMin : CGFloat =  10.0
    var rectHeightMax : CGFloat = 120.0
    
    // Rectangle border, if stroke is used
    var lineWidth : CGFloat = 5.0
    
    // Color
    var colorMin : CGFloat = 0.1
    var colorMax : CGFloat = 1.0
    var alphaMin : CGFloat = 0.2
    var alphaMax : CGFloat = 0.8
    var useAlpha           = false
    
    
    // Border size for the entire view
    var borderWidth : CGFloat = 10.0
    
    // Speed
    var delay : NSTimeInterval = 0.5
    
    // The retained layer
    var drawLayer : CGLayerRef? = nil
    
    // Must be retained for start and stop
    var timer : NSTimer? = nil

    
    //==============================================================================
    func getRandomFromFloatMin(min: CGFloat, thruFloatMax max: CGFloat)-> CGFloat
    {
        // Three decimal places
        let accuracy : CGFloat = 1000.0
        
        let scaledMin : CGFloat = min * accuracy
        let scaledMax : CGFloat = max * accuracy
        
        // arc4random returns unsigned 64 bit value, so divide by 2
        let randomNum = Int(arc4random() / 2)
        
        // Put the value in the specified range of values
        let randomInRange = CGFloat(randomNum % Int(scaledMax - scaledMin)) / accuracy + min
        
        return randomInRange
    }
    //==============================================================================

    
    
    
    
    //==============================================================================
    func getRandomColor() -> UIColor
    {
        // Random values for color RGB and possible alpha
        // The next line is what we would need without the random function
        // let red=CGFloat(Int(arc4random())%Int(100-100*colorMin))/100.0+colorMin
        let red   = getRandomFromFloatMin(colorMin, thruFloatMax: colorMax)
        let green = getRandomFromFloatMin(colorMin, thruFloatMax: colorMax)
        let blue  = getRandomFromFloatMin(colorMin, thruFloatMax: colorMax)
        var alpha : CGFloat = 100.0
        
        // If using a random alpha is specified
        if useAlpha
        { alpha = getRandomFromFloatMin(alphaMin, thruFloatMax: alphaMax) }
        
        // Create the color
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
    
    //==============================================================================
    
    
    

}
