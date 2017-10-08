//
//  PixabayAPI.m
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import "PixabayAPI.h"
#import "Dog.h"

@implementation PixabayAPI

+(NSString *) apiKey
{
    return @"6647843-3cb1d4df951ead26ff193b96d";
}

static int pageNumber = 1;

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

- (void) saveDogIDsWithDogs:(NSArray *)dogs
{
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

- (NSArray *) responseArrayWithPageNumber:(NSNumber *)pageNumber error:(NSError **)errorRef
{
    __block NSArray *retArray;
    NSString *urlString = [NSString stringWithFormat:@"https://pixabay.com/api/?key=%@&q=dog&image_type=photo&category=animals&page=%@", PixabayAPI.apiKey, pageNumber];
    NSURL *URL = [NSURL URLWithString:urlString];
    dispatch_semaphore_t semaphone = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:NULL delegateQueue:NULL];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:
                              ^(NSData * data, NSURLResponse * response, NSError * error)
    {
        *errorRef = error;
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *) response;
        
        // CHECK: Response status code should be in 2xx range.
        
        if (!error && !(urlResponse.statusCode <= 299 && urlResponse.statusCode >= 200)) {
            NSString * localizedDescription = [NSString stringWithFormat:@"Status code error: %@", [NSNumber numberWithInteger:urlResponse.statusCode]];
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(localizedDescription, nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Status code is not within 2xx range.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check URLRequest or connection. Otherwise contact the developer.", nil)
                                       };
            NSError *statusCodeError = [NSError errorWithDomain:@"NSPixaDogErrorDomain" code:102 userInfo:userInfo];
            *errorRef = statusCodeError;
        }
        
        if (*errorRef == NULL) {
            id JSONResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:*&errorRef];
            NSArray *responseArray = JSONResponse[@"hits"];
            retArray = [responseArray copy];
        }
        dispatch_semaphore_signal(semaphone);
    }];
    [task resume];
    dispatch_semaphore_wait(semaphone, DISPATCH_TIME_FOREVER);
    return retArray;
}

- (void) dogsWithCompletion:(void (^)(NSArray*, NSError*))completion
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSArray *savedDogIDs = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedDogIDs"];
        NSMutableArray *retDogs = [NSMutableArray new];
        NSError *error;
        if (savedDogIDs) {
            while (retDogs.count < 20) {
                NSArray *responseArray = [self responseArrayWithPageNumber:[NSNumber numberWithInt:pageNumber] error:&error];
                if (error || !responseArray) break;
                if (responseArray.count < 1) {
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey: NSLocalizedString(@"No results.", nil),
                                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Could not get results for specified query.", nil),
                                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Try changing search term or filters.", nil)
                                               };
                    NSError *noResultsArray = [NSError errorWithDomain:@"NSPixaDogErrorDomain" code:101 userInfo:userInfo];
                    error = noResultsArray;
                    break;
                }
                for (id obj in responseArray) {
                    if (![savedDogIDs containsObject:obj[@"id"]] && retDogs.count < 20) {
                        [retDogs addObject:[Dog dogWithDictionary:obj]];
                    }
                }
                if (retDogs.count < 20) {
                    pageNumber++;
                }
            }
        } else {
            pageNumber = 1;
            NSArray *responseArr = [[self responseArrayWithPageNumber:@1 error:&error] mutableCopy];
            retDogs = [[Dog dogsWithArrayOfDictionaries:responseArr ] mutableCopy];
        }
        [self saveDogIDsWithDogs:retDogs];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(NULL, error);
            } else {
                completion(retDogs, NULL);
            }
        });
    });
}

@end
