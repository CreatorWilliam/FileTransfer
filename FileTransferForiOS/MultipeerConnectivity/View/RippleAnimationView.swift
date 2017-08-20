//
//  RippleAnimationView.swift
//  Connectivity
//
//  Created by William Lee on 20/8/17.
//
//

import UIKit

class RippleAnimationView: UIView {
  
  override func layoutSubviews() {
    
    let radius: CGFloat = UIScreen.main.bounds.width / 4 - 15
    let startAngle: CGFloat = 0
    let endAngle: CGFloat = CGFloat.pi * 2
    let center: CGPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    
    let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = UIColor(colorLiteralRed: 23/255.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    shapeLayer.fillColor = UIColor(colorLiteralRed: 23/255.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    
    self.layer.addSublayer(shapeLayer)
  }
  
}








