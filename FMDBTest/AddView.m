//
//  AddView.m
//  FMDBTest
//
//  Created by gab on 17/7/4.
//  Copyright © 2017年 gab. All rights reserved.
//

#import "AddView.h"

@implementation AddView
-(void)awakeFromNib
{
    [super awakeFromNib];

}
- (IBAction)click:(UIButton *)sender {
    if (self.block) {
        self.block(_name.text,_sex.text,_age.text);
    }
    self.name.text=@"";
    self.sex.text=@"";
    self.age.text=@"";
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
