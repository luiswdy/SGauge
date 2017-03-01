//
//  Gauge.swift
//  HowLoud
//
//  Created by Luis Wu on 5/18/16.
//  Copyright © 2016 Luis Wu. All rights reserved.
//

import UIKit

@IBDesignable
public class SGauge: UIControl {
    private var _value: CGFloat = 0
    private var _animationDuration: Double = Consts.DefaultAnimationDuration
    private var _arcWidth: CGFloat = Consts.DefaultArcWidth
    private var _arcOutlineWith: CGFloat = Consts.DefaultArcOutlineWidth
    
    // Main gauge layer
    private var gaugeLayer: CALayer!
    // other layers
    private var arcLayer: CAShapeLayer!
    private var outlineLayer: CAShapeLayer!
    private var graduationLayer: CAShapeLayer!
    private var needleLayer: CAShapeLayer!
    
    private struct Consts {
        static let Pi = CGFloat(M_PI)
        static let DefaultStartAngle = SGauge.degreeToRadian(210)
        static let DefaultEndAngle = SGauge.degreeToRadian(330)
        static let DefaultArcWidth: CGFloat = 20
        static let DefaultArcOutlineWidth: CGFloat = 1
        static let DefaultMaxValue: CGFloat = 100
        static let DefaultMinValue: CGFloat = 0
        static let DefaultNeedleWidth: CGFloat = 1
        static let DefaultGraduationUnit:CGFloat = 10
        static let DefaultGraduationLength: Int = 10
        static let DefaultAdditionalNeedleLength: Int = 0
        static let DefaultAnimationDuration: Double = 0.1  // in sec
        static let RotationAnimationKey = "Rotate"
    }

    @IBInspectable public var startAngle: CGFloat = Consts.DefaultStartAngle {
        didSet { startAngle = SGauge.degreeToRadian(startAngle) }
    }
    @IBInspectable public var endAngle: CGFloat = Consts.DefaultEndAngle {
        didSet { endAngle = SGauge.degreeToRadian(endAngle) }
    }
    @IBInspectable public var maxValue: CGFloat = Consts.DefaultMaxValue
    @IBInspectable public var minValue: CGFloat = Consts.DefaultMinValue
    @IBInspectable public var arcColor: UIColor  = UIColor.clear
    @IBInspectable public var arcOutlineColor: UIColor  = UIColor.black
    @IBInspectable public var needleColor: UIColor = UIColor.red
    @IBInspectable public var arcWidth: CGFloat {
        get {
            return _arcWidth
        }
        set (newValue) {
            if newValue > 0 {
                _arcWidth = newValue
            }
        }
    }
    @IBInspectable public var arcOutlineWidth: CGFloat {
        get {
            return _arcOutlineWith
        }
        set (newValue) {
            if newValue > 0 {
                _arcOutlineWith = newValue
            }
        }
    }
    @IBInspectable public var needleWidth: CGFloat = Consts.DefaultNeedleWidth
    @IBInspectable public var graduationUnit: CGFloat = Consts.DefaultGraduationUnit
    @IBInspectable public var graduationLength: Int = Consts.DefaultGraduationLength
    @IBInspectable public var additionalNeedleLength: Int = Consts.DefaultAdditionalNeedleLength
    @IBInspectable public var animationDuration: Double {
        get {
            return _animationDuration
        }
        set (newValue) {
            if newValue >= 0 {
                _animationDuration = newValue
            }
        }
    }
    public var value: CGFloat {
        get { return _value }
        set (newValue) {
            let oldValue = _value
            let newValue = newValue > maxValue ? maxValue : ( newValue < minValue ? minValue : newValue )
            
            needleLayer?.removeAnimation(forKey: Consts.RotationAnimationKey)
            
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fillMode = kCAFillModeForwards
            rotateAnimation.fromValue = valueToAngle(oldValue)
            rotateAnimation.toValue = valueToAngle(newValue)
            rotateAnimation.duration = CFTimeInterval(animationDuration)
            rotateAnimation.isRemovedOnCompletion = false
            
            needleLayer?.add(rotateAnimation, forKey: Consts.RotationAnimationKey)
            
            _value = newValue > maxValue ? maxValue : ( newValue < minValue ? minValue : newValue ) // update _value
            
        }
    }
    
    private func getGauge() -> CAShapeLayer {
        let gaugeLayer = CAShapeLayer()
        gaugeLayer.frame = self.bounds
        
        if arcLayer == nil {
            arcLayer = getArcLayer()
        }
        
        if graduationLayer == nil {
            graduationLayer = getGraduationLayer()
        }
        
        if outlineLayer == nil {
            outlineLayer = getOutlineLayer()
        }
        
        if needleLayer == nil {
            needleLayer = getNeedleLayer()
        }
 
        // Processing main gauge layer
        gaugeLayer.addSublayer(arcLayer)
        gaugeLayer.addSublayer(outlineLayer)
        gaugeLayer.addSublayer(graduationLayer)
        gaugeLayer.addSublayer(needleLayer)
        
        return gaugeLayer
    }
    
    private func resetLayers() {
        layer.sublayers = nil
        gaugeLayer = nil
        arcLayer = nil
        outlineLayer = nil
        graduationLayer = nil
        needleLayer = nil
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        resetLayers()
        gaugeLayer = getGauge()
        self.value = self.value + 0 // force update to rotate the needle while changing orientation
        layer.addSublayer(gaugeLayer)
    }
    
    private func valueToAngle(_ value: CGFloat) -> CGFloat {
        return value  * ((endAngle - startAngle) / (maxValue - minValue))
    }
    
    private static func degreeToRadian(_ degree: CGFloat) -> CGFloat {
        return degree / 180 * Consts.Pi
    }
    
    private func getRadius() -> CGFloat {
        if self.bounds.size.width / self.bounds.size.height > 2 { // width : height > 2 : 1
            return self.bounds.size.height - arcWidth - arcOutlineWidth
        } else {
            return self.bounds.size.width / 2 - arcWidth - arcOutlineWidth
        }
    }
    
    private func getArcLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.clear.cgColor // to keep the layer clean (or it would fill with black)
        layer.strokeColor = arcColor.cgColor
        layer.lineWidth = CGFloat(arcWidth)
        layer.path = getArcPath(getRadius())
        return layer
    }
    
    private func getArcPath(_ radius: CGFloat) -> CGPath {
        return UIBezierPath(arcCenter: getAnchorPoint(),
                            radius: radius,
                            startAngle: CGFloat(startAngle),
                            endAngle: CGFloat(endAngle),
                            clockwise: true).cgPath
    }
    
    private func getGraduationLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = arcOutlineColor.cgColor
        layer.lineWidth = CGFloat(arcOutlineWidth)
        layer.path = getGraduationPath(getRadius())
        return layer
    }
    
    private func getGraduationPath(_ radius: CGFloat) -> CGPath {
        let unitAngle = (endAngle - startAngle) / (maxValue - minValue)
        let graduationPath = UIBezierPath()
        
        if (graduationUnit > 0) {
            for i in stride(from:CGFloat(minValue + graduationUnit), to: maxValue, by: graduationUnit) {
                let xStart = getAnchorPoint().x + (radius - arcWidth / 2) * cos(CGFloat(startAngle + i * unitAngle))
                let yStart = getAnchorPoint().y + (radius - arcWidth / 2) * sin(CGFloat(startAngle + i * unitAngle))
                let xEnd = xStart + CGFloat(graduationLength) * cos(CGFloat(startAngle + i * unitAngle))
                let yEnd = yStart + CGFloat(graduationLength) * sin(CGFloat(startAngle + i * unitAngle))
                graduationPath.move(to: CGPoint(x: xStart, y: yStart))
                graduationPath.addLine(to: CGPoint(x: xEnd, y: yEnd))
                
            }
        }
        
        return graduationPath.cgPath
    }
    
    private func getOutlineLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = arcOutlineColor.cgColor
        layer.lineWidth = CGFloat(arcOutlineWidth)
        layer.path = getOutletPath(getRadius())
        return layer
    }
    
    private func getOutletPath(_ radius: CGFloat) -> CGPath {
        // inner arc
        let outlinePath = UIBezierPath(arcCenter: getAnchorPoint(),
                                       radius: radius - CGFloat(arcWidth) / 2,
                                       startAngle: CGFloat(startAngle),
                                       endAngle: CGFloat(endAngle),
                                       clockwise: true)
        // outer arc
        outlinePath.addArc(withCenter: getAnchorPoint(),
                                     radius: radius + CGFloat(arcWidth) / 2,
                                     startAngle: CGFloat(endAngle),
                                     endAngle: CGFloat(startAngle),
                                     clockwise: false)
        outlinePath.close()
        return outlinePath.cgPath
    }
    
    private func getNeedleLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = getNeedlePath(getRadius())
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = needleColor.cgColor
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        layer.frame = self.bounds // restore layer's frame so that it's position won't change after changing its anchorPoint
        layer.lineCap = kCALineCapRound
        layer.lineWidth = CGFloat(needleWidth)
        return layer
    }
    
    private func getNeedlePath(_ radius: CGFloat) -> CGPath {
        let needlePath = UIBezierPath()
        let needleLength = radius + CGFloat(additionalNeedleLength)
        needlePath.move(to: getAnchorPoint())  // move to the center of the view
        needlePath.addLine( to: CGPoint(x: getAnchorPoint().x + needleLength * CGFloat(cos(startAngle)),
            y: getAnchorPoint().y + needleLength * CGFloat(sin(startAngle))))
        return needlePath.cgPath
    }
    
    private func getAnchorPoint() -> CGPoint {
        return CGPoint(x: self.bounds.size.width / 2 , y: self.bounds.size.height)
    }
    
}
