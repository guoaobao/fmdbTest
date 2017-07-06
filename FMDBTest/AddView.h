//
//  AddView.h
//  FMDBTest
//
//  Created by gab on 17/7/4.
//  Copyright © 2017年 gab. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^AddViewBlock)(NSString *name,NSString *sex,NSString *age);

@interface AddView : UIView
@property(nonatomic,strong)IBOutlet UITextField *name;
@property(nonatomic,strong) IBOutlet UITextField *sex;
@property(nonatomic,strong) IBOutlet UITextField *age;
@property(nonatomic,copy) AddViewBlock block;
@end
