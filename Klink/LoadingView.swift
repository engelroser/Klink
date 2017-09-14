//
//  LoadingView.swift
//  Klink
//
//  Created by Mobile App Dev on 15/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var startAngle:CGFloat = 0.0
    var endAngle:CGFloat = 0.0
    var cycle:CGFloat = 1
    var ovalPath:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commontInit()
    }
    
    func commontInit() {
        debugPrint("Common init")
        
    }
    
    override func drawRect(rect: CGRect) {
        ovalPath = UIView(frame: bounds)
        
        let linewidth:CGFloat = 2.0
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = ovalPath.bounds
        shapeLayer.path = UIBezierPath(ovalInRect: ovalPath.bounds).CGPath
        shapeLayer.lineWidth = linewidth
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.orangeColor().CGColor
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.5
        ovalPath.layer.addSublayer(shapeLayer)
        
        let rotationAnimation = CABasicAnimation()
        rotationAnimation.keyPath = "transform.rotation.z"
        rotationAnimation.toValue = CGFloat(M_PI * 2)
        rotationAnimation.duration = 1
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = HUGE
        
        shapeLayer.addAnimation(rotationAnimation, forKey: nil)
        
        
        let imageView = UIImageView(image: UIImage(named: "klink-parachutes"))
        imageView.frame = CGRectInset(ovalPath.bounds, linewidth, linewidth)
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        //        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFit
        
        ovalPath.addSubview(imageView)
        
        self.addSubview(ovalPath)
        
        layer.backgroundColor = UIColor.clearColor().CGColor
        backgroundColor = UIColor.clearColor()
    }
    
    func startAnimating() {
    }
    
    
    private func radians(degrees: CGFloat) -> CGFloat {
        return (degrees * CGFloat(M_PI)) / 180.0
    }
    
}
