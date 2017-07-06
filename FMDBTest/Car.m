//
//  Car.m
//  FMDBTest
//
//  Created by gab on 17/7/5.
//  Copyright © 2017年 gab. All rights reserved.
//

#import "Car.h"

@implementation Car
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.carName forKey:@"carName"];

}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        
        self.carName=[aDecoder decodeObjectForKey:@"carName"];
    }
    return self;
}
@end
