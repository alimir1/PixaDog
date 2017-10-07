//
//  PixabayAPI.m
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import "PixabayAPI.h"
#import "AFNetworking.h"
#import "Dog.h"

@implementation PixabayAPI

+(NSString *) apiKey
{
    return @"6647843-3cb1d4df951ead26ff193b96d";
}

// Singleton

+ (id)shared
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[PixabayAPI alloc] init];
    });
    
    return shared;
}

- (void) saveDogIDsWithDogs:(NSArray *)dogs {
    if (!dogs) {
        return;
    }
    // save
    NSMutableArray *savedDogIDs = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedDogIDs"] mutableCopy];
    NSMutableArray *newDogIDs = [NSMutableArray new];
    [dogs enumerateObjectsUsingBlock:^(Dog *dog, NSUInteger idx, BOOL *stop) {
        [newDogIDs addObject:dog.idNumber];
    }];
    if (!savedDogIDs) {
        savedDogIDs = [NSMutableArray new];
    }
    [savedDogIDs addObjectsFromArray:newDogIDs];
    [[NSUserDefaults standardUserDefaults] setObject:savedDogIDs forKey:@"savedDogIDs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) dogsWithCompletion:(void (^)(NSArray*, NSError*))completion
{
    NSURL *URL = [NSURL URLWithString:@"https://pixabay.com/api/"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString
      parameters:@{@"key":PixabayAPI.apiKey,
                   @"category":@"animals",
                   @"image_type":@"photo",
                   @"q":@"dog"}
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSArray *hits = responseObject[@"hits"];
             NSArray *dogs = [Dog dogsWithArrayOfDictionaries:hits];
             [self saveDogIDsWithDogs:dogs];
             completion(dogs, NULL);
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             completion(NULL, error);
         }
     ];
}

@end
