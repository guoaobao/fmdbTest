//
//  FMDataBase.m
//  FMDBTest
//
//  Created by gab on 17/7/4.
//  Copyright © 2017年 gab. All rights reserved.
//

#import "FMDBTool.h"
#import "FMDB.h"
#import <sqlite3.h>
@implementation FMDBTool
static FMDatabase *dataBase=nil;
+(FMDBTool *)shareInstance
{  static dispatch_once_t onceToken=0;
    static FMDBTool *instace=nil;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc]init ];
        dataBase=[instace creatDataBase];
    });
    return instace;
}
-(NSString *)filePath
{
    NSString *document=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [document stringByAppendingPathComponent:@"student.sqlite"];
}
-(FMDatabase *)creatDataBase
{
    NSLog(@"%@",[self filePath]);
    return [FMDatabase databaseWithPath:[self filePath]];
}

//插入数据
-(void)insertDataWithModel:(Student *)model block:(void(^)(BOOL isSuccess))block{

    if ([dataBase open]) {
        //创建表
        NSString *sql=@"create table if not exists gab_student (id integer primary key autoincrement, name text  not NULL,  sex text not null, age integer not null,grades blob not null,relation blob not null )";
        if ([dataBase executeUpdate:sql]) {
            NSLog(@"表创建成功");
        }else{
            NSLog(@"表创建失败");
            if (block) {
                block(NO);
            }
            return;
        }
        //插入数据
        NSString *insetSql=@"insert into gab_student (name,sex,age,grades,relation) values(?,?,?,?,?);";
        
        if ([dataBase executeUpdate:insetSql,model.name,model.sex,@(model.age),[NSKeyedArchiver archivedDataWithRootObject:model.grades],[self jsonWithDic:model.relation]]) {
            NSLog(@"插入数据成功");
            if (block) {
                block(YES);
            }
//            //3.参数是数组的使用方式
//            [self.db executeUpdate:@“INSERT INTO
//             t_student(name,age) VALUES  (?,?);”withArgumentsInArray:@[name,@(age                 )]];
            
        }else{
            NSLog(@"插入数据失败");
            if (block) {
                block(NO);
            }
        }
         
    }else{
        NSLog(@"数据库打开失败");
        if (block) {
            block(NO);
        }
    }

    [dataBase close];
}
-(NSString *)jsonWithDic:(id)dic
{
    NSError *err=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//查询所有数据
-(NSMutableArray *)selectStudentWithStudent:(Student *)stu{

    NSMutableArray *arr=[[NSMutableArray alloc]init];
    if ([dataBase open]) {
        FMResultSet *resultSet=nil;
        NSString *sql=nil;
        if (stu) {
            sql=@"select *from gab_student where id =?;";
            resultSet=[dataBase executeQuery:sql,[NSNumber numberWithInt:stu.index]];
        }else{
            sql=@"select *from gab_student ;";
            resultSet=[dataBase executeQuery:sql];
        }
        while ([resultSet next]) {
            Student *stu=[[Student alloc]init];
            int id=[resultSet intForColumn:@"id"];//删除的时候剩余数据id不会变
            stu.index=id;
            stu.name=[resultSet objectForColumn:@"name"];
            stu.sex=[resultSet objectForColumn:@"sex"];
            stu.age=[resultSet intForColumn:@"age"];
//            NSString *arraStr=[resultSet objectForColumn:@"grades"];
//            NSData *arrData=[arraStr dataUsingEncoding:NSUTF8StringEncoding];
//            stu.grades=[NSJSONSerialization JSONObjectWithData:arrData options:NSJSONReadingMutableLeaves error:nil];
            NSData *arrData=[resultSet objectForColumn:@"grades"];
            stu.grades=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:arrData];
            NSString *dicStr=[resultSet objectForColumn:@"relation"];
            NSData *dataStr=[dicStr dataUsingEncoding:NSUTF8StringEncoding];
            stu.relation=[NSJSONSerialization JSONObjectWithData:dataStr options:NSJSONReadingMutableLeaves error:nil];
            [arr addObject:stu];
        }
    }else{
    
    NSLog(@"数据库打开失败");
    }
    [dataBase close];
    return arr;
}

//删除数据
-(void)deleteDataWithModel:(Student *)stu block:(void(^)(BOOL isSuccess))block{

    if ([dataBase open]) {
        if (stu) {
            NSString *deSql=@"delete from gab_student where id=?";
            if ([dataBase executeUpdate:deSql,[NSNumber numberWithInt:stu.index]]) {
                NSLog(@"删除成功");
                if (block) {
                    block(YES);
                }
            }else{
                NSLog(@"删除失败");
                if (block) {
                    block(NO);
                }
            }

            
        }else{
            NSString *deSql=@"delete from gab_student";
            if ([dataBase executeUpdate:deSql]) {
                NSLog(@"删除成功");
                if (block) {
                    block(YES);
                }
            }else{
                NSLog(@"删除失败");
                if (block) {
                    block(NO);
                }
            }
        }
        }else{
        NSLog(@"数据库打开失败");
    }
    [dataBase close];

}
-(void)updateWithModel:(Student *)stu block:(void(^)(BOOL isSuccess))block
{
    if ([dataBase open]) {
        NSString *sql=@"update gab_student set name=?,sex=?,age=?,grades=?,relation=? where id=?;";
        if ([dataBase executeUpdate:sql,stu.name,stu.sex,@(stu.age),[NSKeyedArchiver archivedDataWithRootObject:stu.grades],[self jsonWithDic:stu.relation],[NSNumber numberWithInt:stu.index]]) {
            NSLog(@"修改成功");
            if (block) {
                block(YES);
            }
        }else{
            if (block) {
                NSLog(@"修改失败");
                block(NO);
            }
        }
        
    }else{
            NSLog(@"数据库打开失败");
        }
    [dataBase close];
}



@end
