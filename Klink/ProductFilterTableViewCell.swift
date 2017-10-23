//
//  ProductFilterTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 13/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class ProductFilterTableViewCell: UITableViewCell {

    @IBOutlet var selectCircle: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    var category:CategoryModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectCircle.layer.cornerRadius = selectCircle.frame.size.width / 2
        selectCircle.layer.masksToBounds = true
        selectCircle.layer.borderWidth = 1.0

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        self.selectionStyle = .None
    }
    
    func setupView(category: CategoryModel!) {
        self.category = category
        titleLabel.text = category.name
    }
    
    func fillCircleView() {
        selectCircle.backgroundColor = UIColor.kvfKlinkOrangeColor()
        selectCircle.layer.borderColor = UIColor.kvfKlinkOrangeColor().CGColor
    }
    
    func emptyCircleView() {
        selectCircle.backgroundColor = UIColor.clearColor()
        selectCircle.layer.borderColor = UIColor(red: 181/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1).CGColor
    }
    
}
