//
//  CustomFieldLayout.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/23/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class CustomFieldLayout: UICollectionViewLayout
{
    let cellPadding: CGFloat = 6.0
    
    var cellHeight: CGFloat = 150
    var cellWidth: CGFloat = 150
    var soccerLocation = User().selectedLocation
    private var numberOfColumns: Int!
    private var numberOfRows: Int!
    
    // It is two dimension array of itemAttributes
    private var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    // It is one dimension of itemAttributes
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepareLayout()
    {
        if self.cache.isEmpty
        {
            var nextStart: CGPoint = CGPoint.zero
            
            var newWidth: CGFloat = 0
            var newHeight: CGFloat = 0

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
                       
                        var newX = CGFloat(((self.collectionView!.superview!.bounds.size.width - (CGFloat(144) * CGFloat(self.numberOfColumns)))) / 2)
                        let newY = CGFloat((self.collectionView!.superview!.bounds.size.height - self.cellHeight) / 2)
                         
                        switch attributes.indexPath.row
                        {
                            case 0:
                                attributes.frame = CGRectIntegral(CGRectMake(newX - 10, newY, 144, 204))
                            case 1:
                                newX += 140
                                attributes.frame = CGRect(origin: CGPoint(x: newX, y: newY), size: CGSize(width: 144, height: 204))
                        //CGRectIntegral(CGRectMake(156*CGFloat(column), newY, 144, 204))
                            default:
                                break
                        }

                    case "Soccer 5 Tropical Park":
                        switch attributes.indexPath.section
                        {
                        case 0:
                            switch attributes.indexPath.row {
                            case 0:
                                attributes.frame = CGRectIntegral(CGRectMake(32, 300*CGFloat(row) + 50, 183, 150))
                            case 1:
                                attributes.frame = CGRectIntegral(CGRectMake(198*CGFloat(column) + 25, 300*CGFloat(row) + 50, 111, 157))
                            default:
                                break
                            }
                            
                        case 1:
                            switch attributes.indexPath.row {
                            case 0:
                                attributes.frame = CGRectIntegral(CGRectMake(40, 160*CGFloat(row) + 50, 144, 204))
                            case 1:
                                attributes.frame = CGRectIntegral(CGRectMake(165*CGFloat(column) + 25, 160*CGFloat(row) + 50, 144, 204))
                            default:
                                break
                            }
                            
                            
                        default:
                            break
                            
                        }
//                        
                    case "Soccer 5 Kendall":
                        
                        let sectionDictionary = self.getSectionSizesForField("Soccer 5 Kendall")
                        
                        var columnHeight = 0
                        
                        for (key, value) in sectionDictionary
                        {
                            let sectionSizes = value as [CGSize]
                            
                            columnHeight += Int(sectionSizes.first!.height)
                            
                            if key <= 1
                            {
                                columnHeight += Int(cellPadding)
                            }
                        }
                        
                        //let columnHeight = firstSectionHeight + cellPadding + 100 + cellPadding + 100

                        
                        switch attributes.indexPath.section
                        {
                            case 0:
                                
                                var rowWidth = 0
                                
                                let sectionSizes = sectionDictionary[0]
                                
                                for size in sectionSizes!
                                {
                                    rowWidth += Int(size.width)
                                    
                                    if size != sectionSizes?.last
                                    {
                                        rowWidth += Int(cellPadding)
                                    }
                                }
                                
                                switch attributes.indexPath.row
                                {
                                    case 0:
                                        
                                        newWidth = sectionSizes!.first!.width
                                        newHeight = sectionSizes!.first!.height
                                        
                                        nextStart.x = CGFloat(((self.collectionView!.bounds.size.width - CGFloat(rowWidth))) / 2)
                                        
                                        nextStart.y = CGFloat((self.collectionView!.bounds.size.height - CGFloat(columnHeight)) / 2)
                                        
                                        attributes.frame = CGRect(origin: nextStart, size: CGSize(width: newWidth, height: newHeight))
                                        
                                        print("SECTION 0, ROW 0 ATTRIBUTES: \(attributes.frame)")
                                        
                                        nextStart.x += (newWidth + cellPadding)
                                    
                                        break
                                    
                                    case 1:
                                        newWidth = sectionSizes!.last!.width
                                        newHeight = sectionSizes!.last!.height
                                        
                                        attributes.frame = CGRect(origin: nextStart, size: CGSize(width: newWidth, height: newHeight))
                                        
                                        print("SECTION 0, ROW 1 ATTRIBUTES: \(attributes.frame)")
                                        
                                       // nextStart.x -= (newWidth + cellPadding)
                                        nextStart.y += (newHeight + cellPadding)
                                        //CGRectIntegral(CGRectMake(156*CGFloat(column), newY, 144, 204))
                                        break
                                    
                                    default:
                                        break
                                }
                            
                                break
                        
                        
                            case 1:
                                var rowWidth = 0
                                
                                let sectionSizes = sectionDictionary[1]
                                
                                for size in sectionSizes!
                                {
                                    rowWidth += Int(size.width)
                                    
                                    if size != sectionSizes?.last
                                    {
                                        rowWidth += Int(cellPadding)
                                    }
                                }
                                
                               // newWidth = 141
                               // newHeight = 100
                        
                                switch attributes.indexPath.row
                                {
                                    case 0:
                                        newWidth = sectionSizes!.first!.width
                                        newHeight = sectionSizes!.first!.height
                                        
                                        nextStart.x = CGFloat(((self.collectionView!.bounds.size.width - (CGFloat(newWidth) * CGFloat(self.numberOfColumns)))) / 2)
                                        // newY = CGFloat((self.collectionView!.superview!.bounds.size.height - (CGFloat(newHeight) * CGFloat(self.numberOfRows))) / 2)
                                        
                                        attributes.frame = CGRect(origin: nextStart, size: CGSize(width: newWidth, height: newHeight))
                                        
                                        print("SECTION 1, ROW 0 ATTRIBUTES: \(attributes.frame)")
                                        
                                        nextStart.x += (newWidth + cellPadding)
                                    
                                        break
                                //CGRectIntegral(CGRectMake(150*CGFloat(column), 300*CGFloat(row), 140, 204))
                                    
                                    case 1:
                                        newWidth = sectionSizes!.last!.width
                                        newHeight = sectionSizes!.last!.height
                                        
                                        attributes.frame = CGRect(origin: nextStart, size: CGSize(width: newWidth, height: newHeight))
                                        
                                        print("SECTION 1, ROW 1 ATTRIBUTES: \(attributes.frame)")
                                    
                                        //nextStart.x -= (newWidth + cellPadding)
                                        nextStart.y += (newHeight + cellPadding)
                                    
                                            break
                                    
                                        //attributes.frame = CGRectIntegral(CGRectMake(150*CGFloat(column), 300*CGFloat(row), 140, 204))
                                    
                                        default:
                                            break
                                    }
                            
                                    break
                            
                                case 2:
                                    var rowWidth = 0
                                    
                                    let sectionSizes = sectionDictionary[2]
                                    
                                    for size in sectionSizes!
                                    {
                                        rowWidth += Int(size.width)
                                        
                                        if size != sectionSizes?.last
                                        {
                                            rowWidth += Int(cellPadding)
                                        }
                                    }
                                    
                                    switch attributes.indexPath.row
                                    {
                                        case 0:
                                            newWidth = sectionSizes!.first!.width
                                            newHeight = sectionSizes!.first!.height
                                            
                                            nextStart.x = CGFloat(((self.collectionView!.bounds.size.width - (CGFloat(newWidth) * CGFloat(self.numberOfColumns)))) / 2)
                                            //newY = CGFloat((self.collectionView!.superview!.bounds.size.height - (CGFloat(newHeight) * CGFloat(self.numberOfRows))) / 2)
                                            
                                            attributes.frame = CGRect(origin: nextStart, size: CGSize(width: newWidth, height: newHeight))
                                            
                                            print("SECTION 2, ROW 0 ATTRIBUTES: \(attributes.frame)")
                                            
                                            nextStart.x += (newWidth + cellPadding)
                                        
                                            break
                           
                                            case 1:
                                                newWidth = sectionSizes!.last!.width
                                                newHeight = sectionSizes!.last!.height
                                                
                                                attributes.frame = CGRect(origin: nextStart, size: CGSize(width: newWidth, height: newHeight))
                                            
                                                print("SECTION 2, ROW 1 ATTRIBUTES: \(attributes.frame)")
                                            
                                                //nextStart.x -= (newWidth + cellPadding)
                                                nextStart.y += (newHeight + cellPadding)
                                        
                                                break
                           
                                            default:
                                                break
                                        }
                            
                                    break
                            
                            
                            default:
                                break
                        
                            }
                        
                        
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
    
    
    func getSectionSizesForField(name: String) -> [ Int : [CGSize]]
    {
        var sectionSizeDictionary = [ Int : [CGSize]]()
        
        var sectionSizesOne = [CGSize]()
        
        let firstSize = CGSize(width: 120, height: 203)
        sectionSizesOne.append(firstSize)
        
        let secondSize = CGSize(width: 150, height: 203)
        sectionSizesOne.append(secondSize)
        
        sectionSizeDictionary.updateValue(sectionSizesOne, forKey: 0)
        
        var sectionSizesTwo = [CGSize]()
        
        let firstSizeTwo = CGSize(width: 141, height: 100)
        sectionSizesTwo.append(firstSizeTwo)
        
        let secondSizeTwo = CGSize(width: 141, height: 100)
        sectionSizesTwo.append(secondSizeTwo)
        
        sectionSizeDictionary.updateValue(sectionSizesTwo, forKey: 1)
        
        var sectionSizesThree = [CGSize]()
        
        let firstSizeThree = CGSize(width: 141, height: 100)
        sectionSizesThree.append(firstSizeThree)
        
        let secondSizeThree = CGSize(width: 141, height: 100)
        sectionSizesThree.append(secondSizeThree)
        
        sectionSizeDictionary.updateValue(sectionSizesThree, forKey: 2)
        
        return sectionSizeDictionary
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
