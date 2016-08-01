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
        let scale = sender.scale
        let percentage = (scale-1) / 6

        // 9: start the pinch
        if sender.state == .Began {
            performSegueWithIdentifier("secondSegue", sender: self)
        }
        if sender.state == .Changed {
            print("changed", scale)
            animator.interactiveTransition.updateInteractiveTransition(percentage)
        }
        // 10: add cancellation if pinch in
        if sender.state == .Ended {
            if sender.velocity > 0 {
                animator.interactiveTransition.finishInteractiveTransition()
            } else {
                animator.interactiveTransition.cancelInteractiveTransition()
                print("cancelled")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("set transitioningDelegate")
        let destVC = segue.destinationViewController
        // 1: set delegate and custom modalPresentationStyle
        destVC.transitioningDelegate = animator
        destVC.modalPresentationStyle = .Custom

        // 7: set isInteractive base on the segue
        animator.isInteractive = (segue.identifier == "secondSegue")
    }
}

class MyAnimator: NSObject {
    let DURATION: NSTimeInterval = 1
    var isPresenting = false

    // 6: change to interactive transition
    var isInteractive = false
    var interactiveTransition: UIPercentDrivenInteractiveTransition!
}

extension MyAnimator: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    // 2: implement 2 protocols for UIViewControllerTransitioningDelegate
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

    // 8: implement 1 more protocol from UIViewControllerTransitioningDelegate
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if isInteractive {
            print("setting interactive transitioning")
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            return interactiveTransition
        }
        return nil
    }

    // 3: implement 2 required protocols for UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return DURATION
    }

    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

        // 4: do it first for presenting
        if isPresenting {
            print("animating for presenting")
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
            toVC.view.transform = CGAffineTransformMakeScale(0.01, 0.01)

            UIView.animateWithDuration(DURATION, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: { 
                toVC.view.alpha = 1
                toVC.view.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: { (_) in
                    //transitionContext.completeTransition(true)
                    // 11: if cancel the interactive transition halfway
                    if self.isInteractive {
                        if transitionContext.transitionWasCancelled() {
                            toVC.view.removeFromSuperview()
                            transitionContext.completeTransition(false)
                        } else {
                            transitionContext.completeTransition(true)
                        }
                    } else {
                        transitionContext.completeTransition(true)
                    }
            })

        } else {
            // 5: next for dismissing
            print("animating for dismissing")
            UIView.animateWithDuration(DURATION, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [], animations: {
                fromVC.view.transform = CGAffineTransformMakeScale(0.01, 0.01)
                }, completion: { (_) in
                    fromVC.view.alpha = 0
                    fromVC.view.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }

}
