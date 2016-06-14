//
//  ReservationCollectionView.swift
//  soccer5
//
//  Created by Jennifer Duffey on 6/13/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit


class ReservationCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout
{
    var selectedItem: Int = 0
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func offsetForItem(item: Int) -> CGFloat
    {
        var offset: CGFloat = 0
        for i in 0 ..< item
        {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let cellSize = collectionView(self, layout: self.collectionViewLayout, sizeForItemAtIndexPath: indexPath)
            offset += cellSize.width
        }
        
        let firstIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        let firstSize = collectionView(self, layout: self.collectionViewLayout, sizeForItemAtIndexPath: firstIndexPath)
        
        let selectedIndexPath = NSIndexPath(forItem: item, inSection: 0)
        let selectedSize = collectionView(self, layout: self.collectionViewLayout, sizeForItemAtIndexPath: selectedIndexPath)
        
        offset -= (firstSize.width - selectedSize.width) / 2.0
        
        return offset
    }
    
    func selectItem(item: Int, animated: Bool, notifySelection: Bool)
    {
        self.selectItemAtIndexPath(NSIndexPath(forItem: item, inSection: 0), animated: animated, scrollPosition: .None)
        self.scrollToItem(item, animated: animated)
        
        self.selectedItem = item
        
    //    if notifySelection
      //  {
            
        //}
    }
    
    func scrollToItem(item: Int, animated: Bool = false)
    {
        self.setContentOffset(CGPoint(x: self.offsetForItem(item), y: self.contentOffset.y), animated: animated)
    }
    
    
    /*
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let numberOfItems = self.dataSource?.collectionView(self, numberOfItemsInSection: 0)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        let numberOfItems = self.dataSource?.collectionView(self, numberOfItemsInSection: 0)
            
        if numberOfItems > 0
        {
            
        }
        
    }
    */
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: 60, height: 50)
    }
    
    

}
