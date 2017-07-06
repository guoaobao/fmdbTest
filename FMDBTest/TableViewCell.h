//
//  TableViewCell.h
//  FMDBTest
//
//  Created by gab on 17/7/4.
//  Copyright © 2017年 gab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
@interface TableViewCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel *name;
@property(nonatomic,strong) IBOutlet UILabel *sex;
@property(nonatomic,strong) IBOutlet UILabel *age;
@property(nonatomic,strong) Student *studentModel;
@end
