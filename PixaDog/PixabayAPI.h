//
//  PixabayAPI.h
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PixabayAPI : NSObject
+ (id)shared;
- (void) dogsWithSearchTerm:(NSString *)searchTerm completion:(void (^)(NSArray*, NSError*))completion;
@end
