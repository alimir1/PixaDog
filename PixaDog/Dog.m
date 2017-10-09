//
//  Dog.m
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import "Dog.h"

#pragma mark - Class extension

@interface Dog ()

@property (readwrite, nonatomic) NSNumber *idNumber;
@property (readwrite, nonatomic) NSURL *previewImageURL;
@property (readwrite, nonatomic) NSURL *imageURL;

@end

@implementation Dog

#pragma mark - Initializers

- (id) init
{
    return [self initWithIDNumber:NULL previewImageURL:NULL imageURL:NULL];
}

- (id) initWithIDNumber:(NSNumber *)idNumber previewImageURL:(NSURL *)previewURL imageURL:(NSURL *)imageURL
{
    self = [super init];
    
    if (self) {
        _idNumber = idNumber;
        _previewImageURL = previewURL;
        _imageURL = imageURL;
    }
    
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    
    NSString *previewURLString = dictionary[@"previewURL"];
    NSString *imageURLString = dictionary[@"webformatURL"];
    NSNumber *idNumber = dictionary[@"id"];
    
    NSURL *previewImageURL = [NSURL URLWithString:previewURLString];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    return [self initWithIDNumber:idNumber previewImageURL:previewImageURL imageURL:imageURL];
}

#pragma mark - Factory Methods

+ (Dog *)dogWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

+ (NSArray *)dogsWithArrayOfDictionaries:(NSArray *)dictionaries
{
    NSMutableArray *dogs = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in dictionaries) {
        Dog *dog = [Dog dogWithDictionary:dict];
        [dogs addObject:dog];
    }
    
    return dogs;
}

@end
