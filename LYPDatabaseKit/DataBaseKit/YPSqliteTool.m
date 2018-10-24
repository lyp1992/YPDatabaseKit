//
//  YPSqliteTool.m
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import "YPSqliteTool.h"
#import "sqlite3.h"

#define Kcache NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@implementation YPSqliteTool

sqlite3 *ppdb;

+(BOOL)dealWithSql:(NSString *)sql uid:(NSString *)uid{
//    1. 打开数据库
    if (![self openDBWithUid:uid]) {
        NSLog(@"失败");
        return NO;
    }
//    2.执行语句
//    NSError *error;
    BOOL result = sqlite3_exec(ppdb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
  
//    3.关闭数据库
    [self closeDB];
    
    return result;
}

+(BOOL)dealWithSqls:(NSArray *)sqls uid:(NSString *)uid{
    
    [self openDBWithUid:uid];
    
//    1.开启事务
    sqlite3_exec(ppdb, @"begin transaction;".UTF8String, nil, nil, nil);
//    2.执行语句
    for (NSString *sql in sqls) {
        BOOL result = sqlite3_exec(ppdb, sql.UTF8String, nil, nil, nil)==SQLITE_OK;
        if (result == NO) {
//            回滚
            sqlite3_exec(ppdb, @"rollback transaction;".UTF8String, nil, nil, nil);
            return NO;
        }
    }
    sqlite3_exec(ppdb, @"commit transaction".UTF8String, nil, nil, nil);
//    3.判断是否成功
    
//    4.关闭
    [self closeDB];
    return YES;
}

// 一条记录
// m列名1 = 列值1 列名2 = 列值2
+(NSArray<NSDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid
{
//    打开数据库
    [self openDBWithUid:uid];
//    准备语句，预处理语句
    
    /**
     @param ppdb 操作数据库
     @param sql.UTF8String sql语句
     @param nByte#> 字节长度 description#>
     @param ppStmt#> 准备语句对象 description#>
     @param pzTail#> 按照参数3的长度，截取参数2 里面剩余的字符串 description#>
     @return 布尔值
     */
    sqlite3_stmt *ppStmt;
    BOOL result = sqlite3_prepare_v2(ppdb, sql.UTF8String, -1, &ppStmt, nil) == SQLITE_OK;
    if (!result) {
        NSLog(@"准备语句失败");
        return nil;
    }
    
//    执行语句
    NSMutableArray *rowDicArray = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        
//        每次循环，代表一条记录
//        解析这条记录
//        获取列的个数
        int columnCount = sqlite3_column_count(ppStmt);
//        遍历所有的字段
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        for (int i = 0; i<columnCount; i++) {
//            解析一列
         const char *cn = sqlite3_column_name(ppStmt, i);
            NSString *columeName = [NSString stringWithUTF8String:cn];
//            获取这一列的什么类型，根据不同的类型，使用不同的函数，进行获取响应这列的数据
//#define SQLITE_INTEGER  1
//#define SQLITE_FLOAT    2
//#define SQLITE_BLOB     4
//#define SQLITE_NULL     5
//#ifdef SQLITE_TEXT
            int type = sqlite3_column_type(ppStmt, i);
            id value;
            switch (type) {
                case SQLITE_INTEGER:
                {
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                }
                case SQLITE_FLOAT:
                {
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                }
                case SQLITE_BLOB:
                {
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                }
                case SQLITE_TEXT:
                {
                    const char *temp = (const char *) sqlite3_column_text(ppStmt, i);
                    NSString *tempStr = [NSString stringWithUTF8String:temp];
                    value = tempStr;
                    break;
                }
                case SQLITE_NULL:
                {
                    value = @"";
                    break;
                }
                default:
                    break;
            }
            [rowDic setObject:value forKey:columeName];
            [rowDicArray addObject:rowDic];
        }
    }
    
//    释放资源
    sqlite3_finalize(ppStmt);
    
    [self closeDB];
    return rowDicArray;
}

+(BOOL)openDBWithUid:(NSString *)uid{
//    1.数据库路径
    NSString *dbPath = [Kcache stringByAppendingPathComponent:@"common.sqlite"];
    if (uid.length > 0) {
        dbPath = [Kcache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",uid]];
    }

//    2.一个j已经打开的数据库
    BOOL result = sqlite3_open(dbPath.UTF8String, &ppdb)==SQLITE_OK;
    if (result) {
        NSLog(@"数据库已经被打开");
    }else{
        NSLog(@"数据库打开失败");
    }
    
    return result;
}
+(void)closeDB{
    sqlite3_close(ppdb);
}

@end
