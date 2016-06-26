//
//  MenuItemsAnimator.swift
//  FlipSideMenu
//
//  Created by ZachZhang on 16/6/26.
//  Copyright © 2016年 ZachZhang. All rights reserved.
//

import UIKit

class MenuItemsAnimator {
    var completion: () -> Void = {}
    var duration: CFTimeInterval = 0.0
    
    private let layers: [CALayer]
    private let startAngle : CGFloat
    private let endAngle : CGFloat
    
    init(views: [UIView], startAngle: CGFloat, endAngle: CGFloat) {
        self.layers = views.map({$0.layer})
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
    
    // start animating
    func start() {
        let count = Double(layers.count)
        let duration = count * self.duration / (4*count - 3)
        for (index, layer) in self.layers.enumerate() {
            layer.transform = transformRotationLayer(layer, angle: startAngle)
            
            let delay = 3 * Double(index) * duration / count
            UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseIn, animations: {
                layer.transform = self.transformRotationLayer(layer, angle: self.endAngle)
                }, completion: nil)
        }
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(self.duration * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()){
            self.completion()
        }
    }
    
    // MARK: return layer's transform for animating
    private func transformRotationLayer(layer: CALayer, angle: CGFloat) -> CATransform3D {
        let offset = layer.bounds.width / 2.0
        
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        
        transform = CATransform3DTranslate(transform, -offset, 0, 0)
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        transform = CATransform3DTranslate(transform, offset, 0, 0)
        
        return transform
    }
}
