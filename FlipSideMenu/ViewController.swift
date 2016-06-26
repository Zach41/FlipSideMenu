//
//  ViewController.swift
//  FlipSideMenu
//
//  Created by ZachZhang on 16/6/26.
//  Copyright © 2016年 ZachZhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var selectedItem = 0
    
    lazy private var menuAnimator: MenuTransitionAnimator! = MenuTransitionAnimator(mode: .Presentation, tappedOutsideHandler: {
        [unowned self] in
        self.dismissViewControllerAnimated(true, completion:nil)
    })
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier, segue.destinationViewController) {
        case (.Some("presentMenu"), let menu as MenuViewController):
            menu.delegate = self
            menu.selectedItem = self.selectedItem
            menu.transitioningDelegate = self
            menu.modalPresentationStyle = .Custom
        default:
            super.prepareForSegue(segue, sender: sender)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : MenuViewControllerDelegate {
    func menu(menu: MenuViewController, didSelectItemAtIndex index: Int) {
        print("menu %d was selected.", index)
        self.selectedItem = index
    }
    
    func menuDidCancel(menu: MenuViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController : UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return menuAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .Dismissal, tappedOutsideHandler: nil)
    }
}

