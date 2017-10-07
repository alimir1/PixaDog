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
#import "UIImageView+AFNetworking.h"
#import "Dog.h"
#import "PixabayAPI.h"
#import "MBProgressHUD.h"

@interface DogsGridVC ()

@end

@implementation DogsGridVC

#pragma mark - Lifecycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.collectionViewLayout = [[DogImageFlowLayout alloc] init];
    [self fetchDogs];
}

- (void)fetchDogs
{
    [MBProgressHUD showHUDAddedTo:self.view animated:@YES];
    [PixabayAPI.shared dogsWithCompletion:^(NSArray *dogs, NSError *error){
        if (dogs) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dogs = dogs;
                [self.collectionView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:@YES];
            });
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Target-Actions
- (IBAction)onFetchDogsTap:(UIButton *)sender {
    [self fetchDogs];
}

- (IBAction)onClearHistoryTap:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedDogIDs"];
}

#pragma mark - CollectionView methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DogCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dogCollectionCell" forIndexPath:indexPath];
    Dog *dog = self.dogs[indexPath.row];
    [cell.dogImageView setImageWithURL:dog.imageURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dogs.count;
}

@end
