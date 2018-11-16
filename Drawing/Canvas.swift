//
//  Canvas.swift
//  Drawing
//
//  Created by user04 on 2018/8/10.
//  Copyright © 2018年 jerryHU. All rights reserved.
//

import UIKit

class Canvas: UIView {
    
    var lineColor:UIColor = UIColor.black
    lazy var lineWidth:CGFloat = 9
    var path:UIBezierPath!
    var touchPoint:CGPoint!
    var startingPoint:CGPoint!
    var layerArr = NSMutableArray()
    var colorArr = NSMutableArray()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startingPoint = touches.first?.location(in: self)
        path = UIBezierPath()
        path.move(to: startingPoint)
        layerArr.add(path)
        colorArr.add(lineColor)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches
        let currentPoint:CGPoint! = touch.first?.location(in: self)
        let previousPoint:CGPoint! = touch.first?.previousLocation(in: self)
        let x:CGFloat! = (currentPoint.x + previousPoint.x)/2
        let y:CGFloat! = (currentPoint.y + previousPoint.y)/2
        path.addQuadCurve(to: currentPoint, controlPoint: CGPoint(x: x, y: y))
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if(layerArr.count > 0){
            var i = 0
            for pathaa in layerArr {
                path.lineWidth = lineWidth
                (colorArr[i] as AnyObject).setStroke()
                (pathaa as AnyObject).stroke(with: CGBlendMode.destinationIn, alpha: 1.0)
                (pathaa as AnyObject).stroke()
                i += 1
            }
        }
        super.draw(rect)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches
        let currentPoint:CGPoint! = touch.first?.location(in: self)
        let previousPoint:CGPoint! = touch.first?.previousLocation(in: self)
        let x:CGFloat! = (currentPoint.x + previousPoint.x)/2
        let y:CGFloat! = (currentPoint.y + previousPoint.y)/2
        path.addQuadCurve(to: currentPoint, controlPoint: CGPoint(x: x, y: y))
        self.setNeedsDisplay()
    }
    
    func clearCanvas(){
        if(path != nil){
            path.removeAllPoints()
            colorArr.removeAllObjects()
            layerArr.removeAllObjects()
            self.layer.sublayers = nil
            self.setNeedsDisplay()
        }
    }
    
    func undo(){
        if(layerArr.count > 0){
            layerArr.removeLastObject()
            colorArr.removeLastObject()
            self.setNeedsDisplay()
        }
    }
    
    func asImage() -> UIImage {
        self.backgroundColor = UIColor.white
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds:self.bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            // Fallback on earlier versions
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        }
    }
    
}
