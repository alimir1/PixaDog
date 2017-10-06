//
//  DogCollectionViewCell.m
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import "DogCollectionViewCell.h"

@implementation DogCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.dogImageView.image = nil; // Prevent wrong image to be displayed (due to collectionView reusing cells)
}

@end
