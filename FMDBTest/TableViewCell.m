//
//  TableViewCell.m
//  FMDBTest
//
//  Created by gab on 17/7/4.
//  Copyright © 2017年 gab. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setStudentModel:(Student *)studentModel
{
    _studentModel=studentModel;
    self.name.text=[NSString stringWithFormat:@"姓名:%@",_studentModel.name];
    self.sex.text=[NSString stringWithFormat:@"性别:%@",_studentModel.sex];
    self.age.text=[NSString stringWithFormat:@"年龄:%d",_studentModel.age];
    [self acrWithArr:_studentModel.grades];
}
-(void)acrWithArr:(NSMutableArray *)arr
{
    for (int a=0; a<arr.count; a++) {
     
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, a*21+40, 180, 21)];
        Car *car=arr[a];
        lab.text=[NSString stringWithFormat:@"车名:%@",car.carName];
        [self.contentView addSubview:lab];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
