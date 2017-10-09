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
#import "SCLAlertView.h"

@interface DogsGridVC ()
@end

@implementation DogsGridVC

#pragma mark - Lifecycles

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.collectionViewLayout = [[DogImageFlowLayout alloc] init];
    [self fetchDogs];
}

#pragma mark - Helpers

- (void)fetchDogs {
    [MBProgressHUD showHUDAddedTo:self.view animated:@YES];
    [PixabayAPI.shared dogsWithCompletion:^(NSArray *dogs, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:@YES];
        if (dogs) {
            self.dogs = dogs;
            [self.collectionView reloadData];
        } else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            NSString *errorMessage = [NSString stringWithFormat:@"%@", error.localizedDescription];
            [alert showError:self title:@"Error" subTitle:errorMessage closeButtonTitle:@"OK" duration:0.0f];
        }
    }];
}

#pragma mark - Target-Actions

- (IBAction)onFetchDogsTap:(UIButton *)sender {
    [self fetchDogs];
}

- (IBAction)onClearHistoryTap:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedDogIDs"];
    SCLAlertView *successNotice = [[SCLAlertView alloc] init];
    [successNotice showSuccess:self title:@"History cleared!" subTitle:@"Your image browing history has been cleared." closeButtonTitle:@"Ok" duration:0.0f];
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
