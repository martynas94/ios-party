//
//  LoadingCircleView.swift
//  tesonetTestApp
//
//  Created by Martynas P on 01/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import UIKit

class LoadingCircleView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let color = UIColor.white
        let gradientLayer = FadingGradientCircleLayer(bounds: self.bounds, color: color, linewidth: 6)
        self.layer.addSublayer(gradientLayer)
    }

    func startRotating() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = TimeInterval(1.5)
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }

    func stopRotating() {
        self.layer.removeAnimation(forKey: "transform.rotation")
    }
}

class FadingGradientCircleLayer: CALayer {

    override init () {
        super.init()
    }

    convenience init(bounds: CGRect, color: UIColor, linewidth: CGFloat) {
        self.init()
        self.bounds = bounds
        self.position = CGPoint(x: bounds.width/2, y: bounds.height/2)

        let colorSections = 4
        let colors : [UIColor] = self.fadeColors(from: color, withFades: colorSections)

        for i in 0..<colors.count-1 {
            let graint = CAGradientLayer()
            graint.bounds = CGRect(origin:CGPoint.zero, size: CGSize(width:bounds.width/2,height:bounds.height/2))
            let valuePoint = self.positionArrayWith(bounds: self.bounds)[i]
            graint.position = valuePoint
            let fromColor = colors[i]
            let toColor = colors[i+1]
            let colors : [CGColor] = [fromColor.cgColor,toColor.cgColor]
            let stopOne: CGFloat = 0.0
            let stopTwo: CGFloat = 1.0
            let locations : [CGFloat] = [stopOne,stopTwo]
            graint.colors = colors
            graint.locations = locations as [NSNumber]
            graint.startPoint = self.startPoints()[i]
            graint.endPoint = self.endPoints()[i]
            self.addSublayer(graint)

            let shapelayer = CAShapeLayer()
            let rect = CGRect(origin:CGPoint.zero,size:CGSize(width:self.bounds.width - 2 * linewidth,height: self.bounds.height - 2 * linewidth))
            shapelayer.bounds = rect
            shapelayer.position = CGPoint(x:self.bounds.width/2,y: self.bounds.height/2)
            shapelayer.strokeColor = UIColor.blue.cgColor
            shapelayer.fillColor = UIColor.clear.cgColor
            shapelayer.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2).cgPath
            shapelayer.lineWidth = linewidth
            shapelayer.lineCap = kCALineJoinBevel
            shapelayer.strokeEnd = 1.0
            self.mask = shapelayer
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func fadeColors(from color: UIColor, withFades fades: Int) -> [UIColor] {
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        color.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)

        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        color.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)

        var result = [UIColor]()

        for i in 0...fades {
            if i == 0 {
                toAlpha = 0.5
            } else if i == fades {
                UIColor.clear.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
            } else {
                toAlpha = toAlpha / CGFloat(fades) * CGFloat(fades - i)
            }

            let oneR:CGFloat = fromR + (toR - fromR)/CGFloat(fades) * CGFloat(i)
            let oneG : CGFloat = fromG + (toG - fromG)/CGFloat(fades) * CGFloat(i)
            let oneB : CGFloat = fromB + (toB - fromB)/CGFloat(fades) * CGFloat(i)
            let oneAlpha : CGFloat = fromAlpha + (toAlpha - fromAlpha)/CGFloat(fades) * CGFloat(i)
            let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
            result.append(oneColor)
        }

        return result
    }

    private func graint(fromColor:UIColor, toColor:UIColor, count:Int) -> [UIColor]{
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)

        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)

        var result : [UIColor]! = [UIColor]()

        for i in 0...count {
            if i == 3 {
                UIColor.init(white: 1, alpha: 0.01).getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
            }
            if i == 4 {
                UIColor.clear.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
            }
            let oneR:CGFloat = fromR + (toR - fromR)/CGFloat(count) * CGFloat(i)
            let oneG : CGFloat = fromG + (toG - fromG)/CGFloat(count) * CGFloat(i)
            let oneB : CGFloat = fromB + (toB - fromB)/CGFloat(count) * CGFloat(i)
            let oneAlpha : CGFloat = fromAlpha + (toAlpha - fromAlpha)/CGFloat(count) * CGFloat(i)
            let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
            result.append(oneColor)
        }
        return result
    }

    private func positionArrayWith(bounds:CGRect) -> [CGPoint]{
        let first = CGPoint(x:(bounds.width/4)*3,y: (bounds.height/4)*1)
        let second = CGPoint(x:(bounds.width/4)*3,y: (bounds.height/4)*3)
        let third = CGPoint(x:(bounds.width/4)*1,y: (bounds.height/4)*3)
        let fourth = CGPoint(x:(bounds.width/4)*1,y: (bounds.height/4)*1)

        return [first,second,third,fourth]
    }

    private func startPoints() -> [CGPoint] {
        return [CGPoint.zero,CGPoint(x:1,y:0),CGPoint(x:1,y:1),CGPoint(x:0,y:1)]
    }

    private func endPoints() -> [CGPoint] {
        return [CGPoint(x:1,y:1),CGPoint(x:0,y:1),CGPoint.zero,CGPoint(x:1,y:0)]
    }

}
