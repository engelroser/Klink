//
//  ItemCardHeaderTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 24/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

protocol ItemCardHeaderCellDelegate {
    func headerCellCloseButtonPressed()
}

class ItemCardHeaderTableViewCell: KlinkBaseTableViewCell {
    
    var delegate:ItemCardHeaderCellDelegate?
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var variantsSegmentControl: UISegmentedControl!
    
    @IBOutlet var segmentHolder: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(product: ProductModel) {
        if let image = product.imagePath {
            
            productImageView.kf_setImageWithURL(NSURL(string: image)!, placeholderImage: nil)
            
//            productImageView.load(image, placeholder: nil, completionHandler: { (url, image, error, cache) -> Void in
//                if error == nil {
//                    self.productImageView.image = image
//                    self.productImageView.contentMode = .ScaleAspectFit
//                }
//            })
        }
        
        productNameLabel.text = product.name
        descLabel.text = product.desc
        
//        var titles:[String] = []
//        
//        for (index, v) in product.variants.enumerate() {
////            print("index: \(index), name: \(v.presentation)")
//            titles.append(v.presentation)
//            //            variantsSegmentControl.setTitle(v.presentation, forSegmentAtIndex: index)
//        }

//        let segmentControl = UISegmentedControl(items: titles)
        
//        segmentHolder.addSubview(segmentControl)
//        se/gmentControl.autoCenterInSuperview()
        
//        variantsSegmentControl.numberOfSegments = product.variants.count
        
        }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        delegate?.headerCellCloseButtonPressed()
    }
    
    @IBAction func plusPressed(sender: AnyObject) {
    }
    
    @IBAction func minusPressed(sender: AnyObject) {
    }
    
    
}
