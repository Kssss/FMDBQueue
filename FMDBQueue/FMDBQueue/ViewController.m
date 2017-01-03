//
//  ViewController.m
//  FMDBQueue
//
//  Created by Vieene on 2016/11/2.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()
{
    FMDatabaseQueue * _queue;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatDB];

}
- (void)creatDB
{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"student.sqlite"];
    
    //2.获得数据库
    _queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    NSLog(@"%@",fileName);
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。

    [_queue inDatabase:^(FMDatabase *db) {
        //4.创表

        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id INTEGER PRIMARY KEY AUTOINCREMENT,name text, age integer);"];
        if (result)
        {
            NSLog(@"创建表成功");
        }
    }];
    

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (int a = 0; a < 100; a ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_queue inDatabase:^(FMDatabase *db) {
                //4.创表
                
                BOOL result = [db executeUpdate:@"insert into t_student (name,age) VALUES (?,?);",@"ADMIN",@(a)];
                if (result)
                {
                    NSLog(@"%@--插入数据成功",[NSThread currentThread]);
                }
            }];
        });
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //2.把任务包装到事务里
        [_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             *rollback =![db executeUpdate:@"insert into t_student (name,age) VALUES (?,?);",@"ADMIN",@100000];
             *rollback =![db executeUpdate:@"insert into t_student (name,age) VALUES (?,?);",@"ADMIN",@100001];
             //         *rollback =[db executeUpdate:@"insert into t_student (name,age33) VALUES (?,?);",@"ADMIN",@100002];
             *rollback =![db executeUpdate:@"insert into t_student (name,age1) VALUES (?,?)",@"ADMIN",@100003];
             
             //         *rollback =[db executeUpdate:@"insert into t_student (name,aaaaa) VALUES (?,?);",@"ADMIN",@100000];
             //         *rollback =  [db executeUpdate:@"INSERT INTO myTable VALUES (?)",@1];
             
         }];
    });

}

@end
