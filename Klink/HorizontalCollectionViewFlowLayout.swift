//
//  HorizontalCollectionViewFlowLayout.swift
//  Klink
//
//  Created by Mobile App Dev on 15/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class HorizontalCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
//    override func collectionViewContentSize() -> CGSize {
//        // Only support single section for now.
//        // Only support Horizontal scroll
////        NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView
////            numberOfItemsInSection:0];
////        
////        CGSize canvasSize = self.collectionView.frame.size;
////        CGSize contentSize = canvasSize;
////        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
////        {
////            NSUInteger rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
////            NSUInteger columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;
////            NSUInteger page = ceilf((CGFloat)count / (CGFloat)(rowCount * columnCount));
////            contentSize.width = page * canvasSize.width;
////        }
////        
////        return contentSize;
//        
//        let count = self.collectionView?.numberOfItemsInSection(0)
//        
//        let canvasSize:CGSize = collectionView!.frame.size
//        var contentSize = canvasSize
//        
//        if scrollDirection == UICollectionViewScrollDirection.Horizontal {
//            let rowCount = (canvasSize.height - itemSize.height) / (itemSize.height + minimumInteritemSpacing) + 1
//            let columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1
//            
//            let page = ceil(CGFloat(count!) / (CGFloat)(rowCount * columnCount))
//            contentSize.width = page * canvasSize.width
//        }
//        print("Content size: \(contentSize)")
//        return contentSize
//        
//    }
//    
//    
//    func frameForItemAtIndexPath(indexPath: NSIndexPath) -> CGRect {
//        let canvasSize = self.collectionView!.frame.size
//        let rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1
//        let columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1
//        let pageMarginX = (canvasSize.width - columnCount * self.itemSize.width - (columnCount > 1 ? (columnCount - 1) * self.minimumLineSpacing : 0)) / 2.0
//        let pageMarginY = (canvasSize.height - rowCount * self.itemSize.height - (rowCount > 1 ? (rowCount - 1) * self.minimumInteritemSpacing : 0)) / 2.0
//        
//        let page = CGFloat(indexPath.row) / (rowCount * columnCount)
//        let remainder = CGFloat(indexPath.row) - page * (rowCount * columnCount)
//        let row = remainder / columnCount
//        let column = remainder - row * columnCount
//        
//        var cellFrame = CGRectZero
//        cellFrame.origin.x = pageMarginX + column * (self.itemSize.width + self.minimumLineSpacing)
//        cellFrame.origin.y = pageMarginY + row * (self.itemSize.height + self.minimumInteritemSpacing)
//        cellFrame.size.width = self.itemSize.width
//        cellFrame.size.height = self.itemSize.height
//        
//        if (self.scrollDirection == UICollectionViewScrollDirection.Horizontal)
//        {
//            cellFrame.origin.x += page * canvasSize.width
//        }
//        print("Cell frame: \(cellFrame)")
//        return cellFrame
//    }
//    
//    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
//        attributes!.frame = frameForItemAtIndexPath(indexPath)
//        return attributes
//    }
//    
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        
//        let originAttrs:NSArray = super.layoutAttributesForElementsInRect(rect)!
//        var attrs:[AnyObject] = []
//        
//        originAttrs.enumerateObjectsUsingBlock { (at, idx, stop) -> Void in
//            var attr:UICollectionViewLayoutAttributes = at as! UICollectionViewLayoutAttributes
//            let idxPath = attr.indexPath
//            let itemFrame = self.frameForItemAtIndexPath(idxPath)
//            if CGRectIntersectsRect(itemFrame, rect) {
//                attr = self.layoutAttributesForItemAtIndexPath(idxPath)!
//                attrs.append(attr)
//            }
//        }
//        
//        return attrs
//    }

}
