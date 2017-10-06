//
//  DogsGridVC.m
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import "DogsGridVC.h"
#import "DogImageFlowLayout.h"
#import "DogCollectionViewCell.h"

@interface DogsGridVC ()

@end

@implementation DogsGridVC

#pragma mark - Lifecycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.collectionViewLayout = [[DogImageFlowLayout alloc] init];
    
}

#pragma mark - CollectionView methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DogCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dogCollectionCell" forIndexPath:indexPath];
    
    cell.dogImageView.image = [UIImage imageNamed:@"dog"];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

@end
