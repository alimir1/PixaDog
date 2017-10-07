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

static int pageNumber = 1;

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

- (void) dogsWithCompletion:(void (^)(NSArray*, NSError*))completion
{
    NSURL *URL = [NSURL URLWithString:@"https://pixabay.com/api/"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString
      parameters:@{@"key":PixabayAPI.apiKey,
                   @"category":@"animals",
                   @"image_type":@"photo",
//                   @"per_page":@3,
//                   @"page":[NSNumber numberWithInt:pageNumber],
                   @"q":@"dog"}
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSArray *hits = responseObject[@"hits"];
             NSArray *dogs = [Dog dogsWithArrayOfDictionaries:hits];
             completion(dogs, NULL);
             pageNumber++;
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             completion(NULL, error);
         }
     ];
}

@end
