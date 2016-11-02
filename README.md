# FMDBQueue
FMDBQueue以及事务处理



//2.把任务包装到事务里  一旦rollback 为YES，那么之前的操作都会回滚。
[_queue inTransaction:^(FMDatabase *db, BOOL *rollback)
{
*rollback =![db executeUpdate:@"insert into t_student (name,age) VALUES (?,?);",@"ADMIN",@100000];
*rollback =![db executeUpdate:@"insert into t_student (name,age) VALUES (?,?);",@"ADMIN",@100001];
//         *rollback =[db executeUpdate:@"insert into t_student (name,age33) VALUES (?,?);",@"ADMIN",@100002];
*rollback =![db executeUpdate:@"insert into t_student (name,age) VALUES (?,?);",@"ADMIN",@100003];

//         *rollback =[db executeUpdate:@"insert into t_student (name,aaaaa) VALUES (?,?);",@"ADMIN",@100000];
//         *rollback =  [db executeUpdate:@"INSERT INTO myTable VALUES (?)",@1];

}];
