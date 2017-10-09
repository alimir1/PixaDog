//
//  DogImageFlowLayout.m
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import "DogImageFlowLayout.h"

@implementation DogImageFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.minimumLineSpacing = 1.0;
        self.minimumInteritemSpacing = 1.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

// creates a 2 by 'x' grid

- (CGSize)itemSize
{
    NSInteger numberOfColumns = 2;
    
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - (numberOfColumns - 1)) / numberOfColumns;
    return CGSizeMake(itemWidth, itemWidth);
}

@end
