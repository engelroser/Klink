//
//  PacksHeaderView.swift
//  Klink
//
//  Created by Mobile App Developer on 27/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

class PacksHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commontInit()
    }
    
    private func commontInit() {
        let imageView = UIImageView(image: UIImage(named: "party_test"), highlightedImage: nil)
        addSubview(imageView)
        imageView.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        imageView.autoPinEdge(.Leading, toEdge: .Leading, ofView: self)
        imageView.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self)
        imageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
    }
}
