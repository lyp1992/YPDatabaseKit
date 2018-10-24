//
//  YPStu.m
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import "YPStu.h"

@implementation YPStu

+ (NSString *)primaryKey{
    return @"stu_id";
}

//+(NSArray *)ignoreColumnNames{
//
//    return @[@"score2"];
//}

+(NSDictionary *)renameNewKeyToOldKeyDic{
    return @{@"name":@"name2"};
}

@end
