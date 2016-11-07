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
    
    @IBAction func onButton(_ sender: AnyObject) {
        print("let's go")
    }

    @IBAction func onPinch(_ sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let percentage = (scale-1) / 6

        // 9: start the pinch
        if sender.state == .began {
            performSegue(withIdentifier: "secondSegue", sender: self)
        }
        if sender.state == .changed {
            print("changed", scale)
            animator.interactiveTransition.update(percentage)
        }
        // 10: add cancellation if pinch in
        if sender.state == .ended {
            if sender.velocity > 0 {
                animator.interactiveTransition.finish()
            } else {
                animator.interactiveTransition.cancel()
                print("cancelled")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("set transitioningDelegate")
        let destVC = segue.destination
        // 1: set delegate and custom modalPresentationStyle
        destVC.transitioningDelegate = animator
        destVC.modalPresentationStyle = .custom

        // 7: set isInteractive base on the segue
        animator.isInteractive = (segue.identifier == "secondSegue")
    }
}

class MyAnimator: NSObject {
    let DURATION: TimeInterval = 1
    var isPresenting = false

    // 6: change to interactive transition
    var isInteractive = false
    var interactiveTransition: UIPercentDrivenInteractiveTransition!
}

extension MyAnimator: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    // 2: implement 2 protocols for UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("presenting")
        isPresenting = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("dismissing")
        isPresenting = false
        return self
    }

    // 8: implement 1 more protocol from UIViewControllerTransitioningDelegate
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if isInteractive {
            print("setting interactive transitioning")
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            return interactiveTransition
        }
        return nil
    }

    // 3: implement 2 required protocols for UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return DURATION
    }

    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        // 4: do it first for presenting
        if isPresenting {
            print("animating for presenting")
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
            toVC.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

            UIView.animate(withDuration: DURATION, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: { 
                toVC.view.alpha = 1
                toVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { (_) in
                    //transitionContext.completeTransition(true)
                    // 11: if cancel the interactive transition halfway
                    if self.isInteractive {
                        if transitionContext.transitionWasCancelled {
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
            UIView.animate(withDuration: DURATION, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [], animations: {
                fromVC.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }, completion: { (_) in
                    fromVC.view.alpha = 0
                    fromVC.view.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }

}
