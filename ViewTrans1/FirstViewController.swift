//
//  ViewController.swift
//  ViewTrans1
//
//  Created by Harley Trung on 4/4/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var animator = MyAnimator()

    @IBAction func onButton(sender: AnyObject) {
        print("let's go")
    }

    @IBAction func onPinch(sender: UIPinchGestureRecognizer) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("set transitioningDelegate")
        let destVC = segue.destinationViewController
        destVC.transitioningDelegate = animator
        destVC.modalPresentationStyle = .Custom
    }
}

class MyAnimator: NSObject {
    let DURATION: NSTimeInterval = 1
    var isPresenting = false
}

extension MyAnimator: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return DURATION
    }

    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

        if isPresenting {

            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
            toVC.view.transform = CGAffineTransformMakeScale(0, 0)

            UIView.animateWithDuration(DURATION, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
                toVC.view.alpha = 1
                toVC.view.transform = CGAffineTransformMakeScale(1, 1)

            }) { (finished) in
                transitionContext.completeTransition(true)
            }
        } else {
            print("hello")
            UIView.animateWithDuration(DURATION, animations: {
                fromVC.view.alpha = 0
                fromVC.view.transform = CGAffineTransformMakeScale(0, 0)
                }, completion: { (finished) in
                    fromVC.view.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }

        print("animating")
    }


    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("presenting")
        isPresenting = true
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("dismissing")
        isPresenting = false
        return self
    }

}

/*
 class MyAnimator: NSObject, UIViewControllerTransitioningDelegate {
 let DURATION: NSTimeInterval = 1
 var isPresenting = false
 var interactiveTransitioning: UIPercentDrivenInteractiveTransition!
 var isInteractive = false

 //    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
 //        print("presenting")
 //    }

 //    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
 //        print("dimissing")
 //    }

 func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
 if isInteractive {
 // ...
 }

 return nil
 }

 //    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
 //
 //    }

 }

 extension MyAnimator: UIViewControllerAnimatedTransitioning {
 func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
 return DURATION
 }

 func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
 print("animating")
 // let containerView =
 // let fromVC =
 // let toVC =

 if isPresenting {
 // animate adding toVC.view into containerView
 } else {
 // animate removing fromVC.view from containerView
 }
 }
 }
 
 */