//
//  MenuTransitionAnimator.swift
//  FlipSideMenu
//
//  Created by ZachZhang on 16/6/26.
//  Copyright © 2016年 ZachZhang. All rights reserved.
//

import UIKit

enum Mode {
    case Presentation
    case Dismissal
}

class MenuTransitionAnimator : NSObject {
    private let duration = 0.5
    private let angle : CGFloat = 2
    private var mode : Mode
    private var tappedOutsideHandler : (() -> Void)?
    
    init(mode: Mode, tappedOutsideHandler: (() -> Void)?) {
        self.mode = mode
        self.tappedOutsideHandler = tappedOutsideHandler
    }
    
    // Mark: Private Methods
    
    // animation for Presentation
    private func animatePresentation(context: UIViewControllerContextTransitioning) {
        let host = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let menu = context.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let containerView = context.containerView()!
        // outside the menu action
        
        let tapButton = UIButton(frame: host.view.frame)
        tapButton.backgroundColor = UIColor.clearColor()
        tapButton.addTarget(self, action: #selector(tapOutside), forControlEvents: .TouchUpInside)
        containerView.addSubview(tapButton)
        
        let view = menu.view
        view.frame = CGRectMake(0, 0, menu.preferredContentSize.width, host.view.bounds.size.height)
        view.autoresizingMask = [.FlexibleRightMargin, .FlexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        containerView.addSubview(view)
        
        animateMenu(menu as! Menu, startAngle: angle, endAngle: 0) {
            context.completeTransition(true)
        }
        
    }
    
    // animation for dismissal
    private func animateDismissal(context: UIViewControllerContextTransitioning) {
        if let menu = context.viewControllerForKey(UITransitionContextFromViewControllerKey) {
            animateMenu(menu as! Menu, startAngle: 0, endAngle: angle) {
                context.completeTransition(true)
            }
        }
    }
    
    private func animateMenu(menu: Menu, startAngle: CGFloat, endAngle: CGFloat, completion: ()->Void) {
        let animator = MenuItemsAnimator(views: menu.menuItems, startAngle: startAngle, endAngle: endAngle)
        animator.completion = completion
        animator.duration = self.duration
        animator.start()
    }
    
    @objc private func tapOutside(button: UIButton) {
        if let handler = self.tappedOutsideHandler {
            handler()
        }
    }
}

// MARK: Extendsions

extension MenuTransitionAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if mode == .Presentation {
            animatePresentation(transitionContext)
        } else {
            animateDismissal(transitionContext)
        }
    }
}
