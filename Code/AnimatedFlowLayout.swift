//
//  AnimatedFlowLayout.swift
//  Gallery
//
//  Created by Boris Bügling on 16/02/15.
//  Copyright (c) 2015 Contentful GmbH. All rights reserved.
//

import UIKit

class AnimatedFlowLayout: UICollectionViewFlowLayout {
    let π = CGFloat(M_PI)
    var indexPathsToAnimate = [NSIndexPath]()

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        indexPathsToAnimate.removeAll()
    }

    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = layoutAttributesForItemAtIndexPath(itemIndexPath)

        if contains(indexPathsToAnimate, itemIndexPath) {
            attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), π)
            attr.center = CGPoint(x: collectionView!.bounds.midX, y: collectionView!.bounds.maxY)

            indexPathsToAnimate.removeAtIndex(find(indexPathsToAnimate, itemIndexPath)!)
        }

        return attr
    }

    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)

        indexPathsToAnimate += updateItems.map({ (element) -> NSIndexPath in
            return (element as UICollectionViewUpdateItem).indexPathAfterUpdate
        })
    }

    override func prepareLayout() {
        if let collectionView = collectionView {
            let width = Int((collectionView.frame.size.width - 3.0) / 3)

            headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 160.0)
            itemSize = CGSize(width: width, height: width)
            minimumInteritemSpacing = 1.0
            minimumLineSpacing = 1.0
        }

        super.prepareLayout()
    }
}