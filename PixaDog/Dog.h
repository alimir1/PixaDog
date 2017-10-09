//
//  Dog.h
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject

#pragma mark - Properties

@property (readonly, nonatomic) NSNumber *idNumber;
@property (readonly, nonatomic) NSURL *previewImageURL;
@property (readonly, nonatomic) NSURL *imageURL;

#pragma mark - Methods

- (id) init;
- (id) initWithIDNumber:(NSNumber *)idNumber previewImageURL:(NSURL *)previewURL imageURL:(NSURL *)imageURL;
+ (Dog *)dogWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)dogsWithArrayOfDictionaries:(NSArray *)dictionaries;

@end
