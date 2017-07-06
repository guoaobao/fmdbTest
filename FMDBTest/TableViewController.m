//
//  TableViewController.m
//  FMDBTest
//
//  Created by gab on 17/7/4.
//  Copyright © 2017年 gab. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "AddView.h"
#import "Student.h"
#import "Car.h"
#import "FMDBTool.h"
#define WEAKSELF __weak typeof(self) weak##Self=self
@interface TableViewController ()
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong) AddView *addView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray *arr=@[@{@"carName":@"hah"},@{@"carName":@"kjjj"}];
//    NSArray *jjjj=[NSArray yy_modelArrayWithClass:[Car class] json:arr];
    _dataArr=[[FMDBTool shareInstance] selectStudentWithStudent:nil];
    if (!_dataArr) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    self.tableView.tableHeaderView=[self creatView];
   
}
-(UIView *)creatView
{
    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    bg.backgroundColor=[UIColor yellowColor];
    NSArray *titleArr=@[@"添加",@"删除全部"];
    for (int a=0; a<2; a++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.frame=CGRectMake(a*(80+5), 0, 80, 60);
        button.tag=a+10;
        [button setTitle:titleArr[a] forState:UIControlStateNormal];
        button.backgroundColor=[UIColor greenColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:button];
    }
    return bg;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(AddView *)addView
{
    if (!_addView) {
        _addView=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AddView class]) owner:nil options:nil][0];
        _addView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    }
    return _addView;
}
-(void)buttonClick:(UIButton *)btn
{
    WEAKSELF;
    if (btn.tag==10) {
        [self.view addSubview:self.addView];
        self.addView.block=^(NSString *name,NSString *sex,NSString *age){
            Student *stu=[[Student alloc]init];
            stu.name=name;
            stu.sex=sex;
            stu.age=[age intValue];
            
            stu.grades=[[NSMutableArray alloc]init];
            for (int a=0; a<4; a++) {
                Car *car=[[Car alloc]init];
                car.carName=@"ccc";
                [stu.grades addObject:car];
            }
            //        stu.grades=(NSMutableArray *)@[@"2",@"2"];
            stu.relation=@{@"f":@"gab",@"m":@"bb"};
            
            [[FMDBTool shareInstance] insertDataWithModel:stu block:^(BOOL isSuccess) {
                if (isSuccess) {
                    [weakSelf.dataArr addObject:stu];
                    [weakSelf.tableView reloadData];
                }
            }];
            
        };
    }else{
    
    [[FMDBTool shareInstance] deleteDataWithModel:nil block:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.tableView reloadData];
        }
        
    }];
    }
 }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableViewCell class]) owner:nil options:nil][0];
    }
    Student *stu=_dataArr[indexPath.row];
    cell.studentModel=stu;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    Student *stu=_dataArr[indexPath.row];
    [self.view addSubview:self.addView];
    self.addView.block=^(NSString *name,NSString *sex,NSString *age){
        stu.name=name;
        stu.sex=sex;
        stu.age=[age intValue];
        [[FMDBTool shareInstance] updateWithModel:stu block:^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.tableView reloadData];
            }else{
                
                }
        }];
    };
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WEAKSELF;
        Student *stu=_dataArr[indexPath.row];
        [[FMDBTool shareInstance] deleteDataWithModel:stu block:^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.dataArr removeObject:stu];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
