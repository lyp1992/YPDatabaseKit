//
//  YPModelTest.m
//  LYPDatabaseKitTests
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YPModel.h"
#import "YPStu.h"

@interface YPModelTest : XCTestCase

@end

@implementation YPModelTest

-(void)testModel{
    
//  NSDictionary * dic = [YPModel modelIvarNameAndIvarType:NSClassFromString(@"YPStu")];
//    NSLog(@"%@",dic);
    
//    NSDictionary *dic = [YPModel modelIvarNameAndSqliteType:NSClassFromString(@"YPStu")];
//    NSLog(@"%@",dic);
    
    NSString *dic = [YPModel modelIvarNameAndSqliteTypeStr:NSClassFromString(@"YPStu")];
    NSLog(@"%@",dic);
}

@end
