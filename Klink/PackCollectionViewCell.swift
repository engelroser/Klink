//
//  PackCollectionViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 27/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import ImageLoader

class PackCollectionViewCell: UICollectionViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var packImageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        packImageView.contentMode = .ScaleAspectFill
        spinner.startAnimating()
    }

    
    func setupView(pack: PackModel!) {
        nameLabel.text = pack.name
        
        if let path = pack.thumbnail {
            packImageView.kf_setImageWithURL(NSURL(string: path)!, placeholderImage: nil)
//            packImageView.load(path)
        }
    }
}
