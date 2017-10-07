//
//  DogsGridVC.h
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DogsGridVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *fetchDogsButton;
@property (strong, nonatomic) IBOutlet UIButton *clearHistoryButton;
@property (nonatomic) NSArray *dogs;

@end
