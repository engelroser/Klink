//
//  ItemCardHolderCollectionViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 15/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class ItemCardHolderCollectionViewCell: UICollectionViewCell {
    
    var cardVC:ItemCardViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    deinit {
        print("ItemCardHolderCollectionViewCell deinit")
    }
    
    override func didMoveToWindow() {
        if window == nil {
//            println("not here :D")
        }
    }

}
