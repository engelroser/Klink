//
//  DiscoverCollectionTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 11/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftColors
import ImageLoader

protocol DiscoverCollectionCellDelegate {
    func didSelectCollection(collection:CollectionModel!)
}

class DiscoverCollectionTableViewCell: KlinkBaseTableViewCell {

    @IBOutlet var leftImageView: UIImageView!
    @IBOutlet var leftImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var rightImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var rightImageView: UIImageView!
    
    @IBOutlet var rightLabelBackgroundView: UIView!
    @IBOutlet var leftLabelBackgroundView: UIView!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    var collectionLeft:CollectionModel!
    var collectionRight:CollectionModel?
    
    var delegate:DiscoverCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftImageView.clipsToBounds = true
        rightImageView.clipsToBounds = true
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func leftTap() {
        print("left tap")
        delegate?.didSelectCollection(collectionLeft)
    }
    
    func rightTap() {
        delegate?.didSelectCollection(collectionRight!)
    }
    
    func setupView(collection1: CollectionModel, collection2: CollectionModel?) {
        leftImageView.userInteractionEnabled = true
        let leftImageTap = UITapGestureRecognizer(target: self, action: "leftTap")
        leftImageView.addGestureRecognizer(leftImageTap)
        
        if let leftImage = collection1.image {
            leftImageView.kf_setImageWithURL(NSURL(string: leftImage)!, placeholderImage: nil)
            
//            leftImageView.load(leftImage, placeholder: nil, completionHandler: { (url, image, error, cache) -> Void in
//                if error == nil {
//                    self.leftImageView.image = image
//                    self.leftImageView.contentMode = .ScaleAspectFill
//                }
//            })
        }
        
        rightImageView.userInteractionEnabled = true
        let rightImageTap = UITapGestureRecognizer(target: self, action: "rightTap")
        rightImageView.addGestureRecognizer(rightImageTap)
        
        
        
        leftLabel.text = collection1.name
        leftLabelBackgroundView.backgroundColor = UIColor(hexString: collection1.color)
        
        self.collectionLeft = collection1
        self.collectionRight = collection2
        
        if let c2 = collection2 {
            if let rightImage = collection2!.image {
                rightImageView.kf_setImageWithURL(NSURL(string: rightImage)!, placeholderImage: nil)
//                rightImageView.load(rightImage, placeholder: nil, completionHandler: { (url, image, error, cache) -> Void in
//                    if error == nil {
//                        self.rightImageView.image = image
//                        self.rightImageView.contentMode = .ScaleAspectFill
//                    }
//                })
            }
            
            
            rightLabel.text = c2.name
            rightLabelBackgroundView.backgroundColor = UIColor(hexString: c2.color)
            rightImageView.hidden = false
            rightLabel.hidden = false
            rightLabelBackgroundView.hidden = false
        } else {
            rightImageView.hidden = true
            rightLabel.hidden = true
            rightLabelBackgroundView.hidden = true
        }
    }
    
    
}
