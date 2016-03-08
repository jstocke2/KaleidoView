//
//  KaleidoView.swift
//  KaleidoView
//
//  Modified for symmetry by Jake Stocker on 3/3/16.
//  Original from Dale Haverstock's template Ios Applications at Kent State University
//  Copyright © 2016 Jake Stocker. All rights reserved.
//

import UIKit

class KaleidoView: UIView {
    
    
    // Rectangle
   
    var rectWidthMin  : CGFloat =  10.0
    var rectWidthMax  : CGFloat = 30.0
    var rectHeightMin : CGFloat =  10.0
    var rectHeightMax : CGFloat = 30.0
    
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
    
    // Speed (gets error prone for symmetry when too fast)
    var delay : NSTimeInterval = 0.7
    
    // The retained layer
    var drawLayer : CGLayerRef? = nil
    
    // Must be retained for start and stop
    var timer : NSTimer? = nil
    var iteration: Int = 0
    
    // rectangular values that must stay constant for symmetric drawing in sets of 4 rectangles
    var x_offset: CGFloat = 20
    var y_offset: CGFloat = 20
    var color = UIColor()
    var rectWidth     : CGFloat =  20.0
    var rectHeight    : CGFloat =  30.0
    
    
    
    
    //==============================================================================
    override func drawRect(rect: CGRect)
    {
    // Get the context being draw upon
    let context = UIGraphicsGetCurrentContext()
    
    if (drawLayer == nil)
    {
        // Create the layer if we don't have one
        let size = CGSizeMake(self.bounds.size.width, self.bounds.size.height)
        drawLayer = CGLayerCreateWithContext(context, size, nil)
    }
    
    
    // Draw to the layer
        self.drawToLayer(&rectWidth,rectHeight: &rectHeight,x_offset: &x_offset,y_offset: &y_offset, iteration: &iteration, color: &color)
    
    // Copy layer to context
    CGContextDrawLayerInRect (context, self.bounds, drawLayer);
    }
    
    //==============================================================================
    func drawToLayer(inout rectWidth: CGFloat, inout rectHeight: CGFloat, inout x_offset: CGFloat, inout y_offset: CGFloat,inout iteration: Int, inout color: UIColor)
    {
    // Shorten names and start from center
    let viewWidth  : CGFloat = (self.bounds.size.width)/2
    let viewHeight : CGFloat = (self.bounds.size.height)/2
    // initalize our point we draw rectangle from
    var draw_x = CGFloat()
    var draw_y = CGFloat()
        
    if (iteration == 0)
    {
        // first iteration make inital values and keep the same for 4 symmetric shapes
    
        // Create the color
        color = getRandomColor()
    
        // Random size
        rectWidth  = getRandomFromFloatMin(rectWidthMin,
            thruFloatMax: rectWidthMax)
        rectHeight = getRandomFromFloatMin(rectHeightMin,
            thruFloatMax: rectHeightMax)
    
        // get the offset from the center
        x_offset = getRandomFromFloatMin(borderWidth,
            thruFloatMax: viewWidth - rectWidth - borderWidth)
        y_offset = getRandomFromFloatMin(borderWidth,
            thruFloatMax: viewHeight - rectHeight - borderWidth)

    
        // find our point based off the same offset for sets of 4 rectangles
        // Keep the rectangle onscreen and entirely in the border
        draw_x = viewWidth - x_offset
        draw_y = viewHeight - y_offset
            ++iteration  // iterate so values stay the same
    }
        
    else if (iteration == 1)
    {
        // draw symmetric to last shape
        draw_x = viewWidth + x_offset
        draw_y = viewHeight + y_offset
        ++iteration
    }
    else if (iteration == 2)
    {
        // draw in pos x neg y space
        draw_x = viewWidth + x_offset
        draw_y = viewHeight - y_offset
        ++iteration
    }
    else if (iteration == 3)
    {
        // draw symmetric to last
        draw_x = viewWidth - x_offset
        draw_y = viewHeight + y_offset
        // set it up after draw to go back to the beginning and make a new rectangle
        iteration = 0
    }
    
    // Create the location/size struct for the rectangle that will be drawn
    let drawingRect = CGRect(x:draw_x, y:draw_y,
    width:rectWidth, height:rectHeight)
    
    // Do the drawing
    drawRectangleUsing(drawingRect, color: color)
    }
    //==============================================================================
    func drawRectangleUsing(theRect : CGRect, color : UIColor)
    {
    // Get layer context
    let layer_context = CGLayerGetContext (drawLayer)
    
    // Set line width, not meaningful if fill
    CGContextSetLineWidth(layer_context, lineWidth)
    
    // Get color components, note the & for the inout parameter
    var red   : CGFloat = 0.0
    var green : CGFloat = 0.0
    var blue  : CGFloat = 0.0
    var alpha : CGFloat = 0.0
    color.getRed(&red, green:&green, blue:&blue, alpha:&alpha)
    
    // Set colors, stroke not used if fill (could do both)
    CGContextSetRGBFillColor(layer_context, red, green, blue, alpha)
    CGContextSetRGBStrokeColor(layer_context, red, green, blue, alpha)
    
    // Draw the rectangle
    CGContextAddRect(layer_context, theRect)
    CGContextDrawPath(layer_context, .Fill)
    }
    
    //==============================================================================
    func startDrawing()
    {
    // Set timer, Target/Action pattern used here
    timer = NSTimer(timeInterval: delay,
    target: self,
    selector: Selector("setNeedsDisplay"),
    userInfo: nil,
    repeats: true)
    
    // Get the runloop, add timer to runloop
    let runLoop = NSRunLoop.currentRunLoop()
    runLoop.addTimer(timer!, forMode: "NSDefaultRunLoopMode")
    }
    
    //==============================================================================
    func stopDrawing()
    {
    // Clear timer
    if let timer2 = timer
    {
    timer2.invalidate()
    }
    self.timer = nil
    }
    
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
    func getRandomFromIntMin(min: Int, thruIntMax max: Int)-> CGFloat
    {
    // arc4random returns unsigned 64 bit value, so divide by 2
    let randomNum = Int(arc4random() / 2)
    
    // Put the value in the specified range of values
    let randomInRange = CGFloat(randomNum % (max - min) + min)
    
    return randomInRange
    }
    
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
}

