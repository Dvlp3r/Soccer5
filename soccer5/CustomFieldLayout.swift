//
//  CustomFieldLayout.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/23/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class CustomFieldLayout: UICollectionViewLayout {
    var cellHeight: CGFloat = 150
    var cellWidth: CGFloat = 150
    var soccerLocation = User().selectedLocation
    private var numberOfColumns: Int!
    private var numberOfRows: Int!
    
    // It is two dimension array of itemAttributes
    private var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    // It is one dimension of itemAttributes
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepareLayout() {
        if self.cache.isEmpty {
        

            self.numberOfColumns = self.collectionView?.numberOfItemsInSection(0)
            self.numberOfRows = self.collectionView?.numberOfSections()
            
            
            // Dynamically change cellWidth if total cell width is smaller than whole bounds
             if (self.collectionView?.bounds.size.width)!/CGFloat(self.numberOfColumns) > cellWidth {
                self.cellWidth = (self.collectionView?.bounds.size.width)!/CGFloat(self.numberOfColumns)
             }
            // Dynamically change cellHeight if total cell height is smaller than whole bounds
             if (self.collectionView?.bounds.size.height)!/CGFloat(self.numberOfRows) > cellHeight {
                self.cellHeight = (self.collectionView?.bounds.size.height)!/CGFloat(self.numberOfRows)
             }
            
            for row in 0..<self.numberOfRows {
                var row_temp = [UICollectionViewLayoutAttributes]()
                for column in 0..<self.numberOfColumns {
                    let indexPath = NSIndexPath(forItem: column, inSection: row)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                    attributes.frame = CGRectIntegral(CGRectMake(cellWidth*CGFloat(column), cellHeight*CGFloat(row), cellWidth, cellHeight))
                    
                    switch User().selectedLocation! {
                    case "Soccer 5 Hialeah":
                       
                        switch attributes.indexPath.row {
                        case 0:
                            attributes.frame = CGRectIntegral(CGRectMake(150*CGFloat(column), 300*CGFloat(row), 150, 300))
                        case 1:
                            attributes.frame = CGRectIntegral(CGRectMake(150*CGFloat(column), 300*CGFloat(row), 150, 300))
                        default:
                            break
                        }
//                    case "Soccer 5 Tropical Park":
//                        
//                    case "Soccer 5 Kendall":
                        
                    default:
                        break
                    }
                    
                    
                    
                    row_temp.append(attributes)
                    
                    self.cache.append(attributes)
                }
                self.itemAttributes.append(row_temp)
            }
        }
    }
    
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: CGFloat(self.numberOfColumns)*cellWidth, height: CGFloat(self.numberOfRows)*cellHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
   
}
