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
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Dog.h"

@interface DogsGridVC ()

@end

@implementation DogsGridVC

#pragma mark - Lifecycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.collectionViewLayout = [[DogImageFlowLayout alloc] init];
    
    [self performTask];
    
}

- (void)performTask
{
    NSURL *URL = [NSURL URLWithString:@"https://pixabay.com/api/"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString
      parameters:@{@"key":@"6647843-3cb1d4df951ead26ff193b96d",
                   @"category":@"animals",
                   @"image_type":@"photo",
                   @"per_page":@10,
                   @"q":@"dog"}
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             if (responseObject) {
                 if (responseObject[@"hits"]) {
                     NSArray *hits = responseObject[@"hits"];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         self.dogs = [Dog dogsWithArrayOfDictionaries:hits];
                         [self.collectionView reloadData];
                     });
                 }
             }
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
}

#pragma mark - CollectionView methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DogCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dogCollectionCell" forIndexPath:indexPath];
    Dog *dog = self.dogs[indexPath.row];
    [cell.dogImageView setImageWithURL:dog.imageURL];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dogs.count;
}

@end
