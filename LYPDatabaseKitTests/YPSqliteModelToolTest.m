//
//  YPSqliteModelToolTest.m
//  LYPDatabaseKitTests
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YPSqliteModelTool.h"
#import "YPStu.h"
#import "YPTable.h"

@interface YPSqliteModelToolTest : XCTestCase

@end

@implementation YPSqliteModelToolTest

-(void)testCreateTable{
    
//    [YPSqliteModelTool createTable:NSClassFromString(@"YPStu") uid:nil];
    
//  NSArray *arr = [YPTable columnSortedNames:NSClassFromString(@"YPStu") uid:nil];
//    NSLog(@"%@",arr);
    
//    BOOL isUpdate = [YPSqliteModelTool isTableRequiredUpdate:NSClassFromString(@"YPStu") uid:nil];
//    XCTAssertFalse(isUpdate);
//    NSLog(@"%@",NSHomeDirectory());
//   BOOL isUpdated = [YPSqliteModelTool updateTable:NSClassFromString(@"YPStu") uid:nil];
//
//    NSLog(@"==%d",isUpdated);
    
}

-(void)testDelete{
    NSLog(@"%@",NSHomeDirectory());
   BOOL isSuccess = [YPSqliteModelTool deleteModels:NSClassFromString(@"YPStu") key:@"name" relation:RelationTypeEqual value:@"lyp" uid:nil];
    XCTAssertFalse(isSuccess);
}

-(void)testUpdate{
    YPStu *stu = [YPStu new];
    stu.stu_id = 8;
    stu.score2 = 12;
    stu.score3 = 78;
    stu.name = @"lyp";
    stu.arr = @[@"lyx",@"ljh"];
     NSLog(@"%@",NSHomeDirectory());
   BOOL isSuccess =  [YPSqliteModelTool saveOrUpdateModel:stu uid:nil];
    
    XCTAssertFalse(isSuccess);
}

-(void)testQuery{
    NSLog(@"%@",NSHomeDirectory());
    NSArray *arr = [YPSqliteModelTool queryAllModels:NSClassFromString(@"YPStu") uid:nil];
    NSLog(@"%@",arr);
}

@end
