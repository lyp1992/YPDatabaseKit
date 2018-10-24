//
//  YPTable.m
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/24.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import "YPTable.h"
#import "YPSqliteTool.h"

@implementation YPTable

+(NSArray *)columnSortedNames:(NSString *)tableName uid:(NSString *)uid{
    
    NSString *sql = [NSString stringWithFormat:@"select sql from sqlite_master where name = '%@'",tableName];
    NSArray *resultArr = [YPSqliteTool querySql:sql uid:uid];
//    NSLog(@"%@",resultArr);
//    {
//        sql = "CREATE TABLE YPStu(name text,score real,stu_id integer,primary key (stu_id))";
//    }
    NSString *createTableSql = resultArr.firstObject[@"sql"];
    NSString *sql1 = [createTableSql componentsSeparatedByString:@"("][1];
    NSArray *columnNameTypes = [sql1 componentsSeparatedByString:@","];
    NSMutableArray *results = [NSMutableArray array];
    for (NSString *columnNameType in columnNameTypes) {
        if ([columnNameType containsString:@"primary"]) {
            continue;
        }
        NSString *columnName = [columnNameType componentsSeparatedByString:@" "][0];
        [results addObject:columnName];
    }
    
    [results sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return results;
}

@end
