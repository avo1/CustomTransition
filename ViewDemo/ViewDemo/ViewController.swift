//
//  ViewController.swift
//  ViewDemo
//
//  Created by Harley Trung on 4/4/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var progressview: ProgressView!
    var progress: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        play()

        let firstView = MyFirstXib(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 150))
        view.addSubview(firstView)
    }

    func methodOne() {
        let nib = UINib(nibName: "MyFirstXib", bundle: nil)
        let objects = nib.instantiateWithOwner(nil, options: nil)
        for object in objects {
            print(object)
        }
        let view1 = objects[0] as! UILabel
        view1.frame.origin.y += 200
        view.addSubview(view1)
    }

    func play() {
        progress = 0
        let w = UIScreen.mainScreen().bounds.width
        progressview = ProgressView(frame: CGRect(x: 10, y: 50, width: w-20, height: 100))
        progressview.backgroundColor = UIColor.whiteColor()
        view.addSubview(progressview)

        NSTimer.scheduledTimerWithTimeInterval(0.2,
                                               target: self,
                                               selector: #selector(self.onTimer(_:)), userInfo: nil, repeats: true)
    }

    func onTimer(timer: NSTimer) {
        progress += 0.05
        print("progress", progress)
        if progress > 1.001 {
            timer.invalidate()
        } else {
            progressview.progress = progress
        }
    }

    @IBAction func onReset(sender: UIButton) {
        progressview.removeFromSuperview()
        play()
    }

    @IBAction func onNext(sender: UIButton) {
        let firstVC = FirstViewController(nibName: "FirstViewController", bundle: nil)
        presentViewController(firstVC, animated: true, completion: nil)
    }
}

