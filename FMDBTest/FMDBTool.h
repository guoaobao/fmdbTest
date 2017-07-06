//
//  FMDataBase.h
//  FMDBTest
//
//  Created by gab on 17/7/4.
//  Copyright © 2017年 gab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
#import "YYModel.h"
@interface FMDBTool : NSObject
+(FMDBTool *)shareInstance;
-(void)insertDataWithModel:(Student *)model block:(void(^)(BOOL isSuccess))block;
-(NSMutableArray *)selectStudentWithStudent:(Student *)stu;
-(void)deleteDataWithModel:(Student *)stu block:(void(^)(BOOL isSuccess))block;
-(void)updateWithModel:(Student *)stu block:(void(^)(BOOL isSuccess))block;
@end
