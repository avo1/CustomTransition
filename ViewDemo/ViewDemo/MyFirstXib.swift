//
//  MyFirstXib.swift
//  ViewDemo
//
//  Created by Harley Trung on 4/4/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class MyFirstXib: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    func initSubviews() {
        // code to load subviews from nib here
        // ...
        let nib = UINib(nibName: "MyFirstXib", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        containerView.frame = bounds
        addSubview(containerView)
    }
}
