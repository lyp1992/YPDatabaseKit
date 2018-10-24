//
//  LYPDatabaseKitTests.m
//  LYPDatabaseKitTests
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YPSqliteTool.h"
@interface LYPDatabaseKitTests : XCTestCase

@end

@implementation LYPDatabaseKitTests


- (void)testExample {
  
    [YPSqliteTool dealWithSql:@"create table if not exists t_stu(id integer primary key autoincrement, name text, age real);" uid:nil];
}

-(void)testQuery{
   NSArray *array = [YPSqliteTool querySql:@"select *from t_stu" uid:nil];
    NSLog(@"==%@",array);
}

@end
