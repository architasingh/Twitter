//
//  User.h
//  twitter
//
//  Created by Archita Singh on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface User : NSObject

// TODO: Add properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;

// TODO: Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
