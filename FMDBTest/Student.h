//
//  Student.h
//  FMDBTest
//
//  Created by gab on 17/7/4.
//  Copyright © 2017年 gab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Car.h"
@interface Student : NSObject
@property(nonatomic,assign) int index;
@property(nonatomic,strong) NSString *name,*sex;
@property(nonatomic,assign) int age;
@property(nonatomic,strong) NSMutableArray *grades;
@property(nonatomic,strong) NSDictionary *relation;
@end
