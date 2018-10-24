//
//  YPModel.m
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import "YPModel.h"
#import <objc/message.h>
#import "YPSqliteModelProtocol.h"

@implementation YPModel

+(NSString *)tableName:(Class)cls{
    return NSStringFromClass(cls);
}
+(NSString *)tmpTableName:(Class)cls{
    return [NSString stringWithFormat:@"%@_tmp",NSStringFromClass(cls)];
}

// 获取这个类的所有成员变量
+(NSDictionary *)modelIvarNameAndIvarType:(Class)cls{
//    获取成员变量列表
    unsigned int outCount;
    Ivar *ivarList = class_copyIvarList(cls, &outCount);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i<outCount; i++) {
//        Ivar
//        获取成员变量名称，类型
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivarList[i])];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        NSArray *ignoreNames = nil;
        if ([cls respondsToSelector:@selector(ignoreColumnNames)]) {
            ignoreNames = [cls ignoreColumnNames];
            if ([ignoreNames containsObject:ivarName]) {
                continue;//结束本次循环
            }
        }
        
//       获取变量类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivarList[i])];
//        切割@“NSString”
        ivarType = [ivarType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        [dic setValue:ivarType forKey:ivarName];
    }
    return dic;
}

+(NSDictionary *)modelIvarNameAndSqliteType:(Class)cls{
    NSDictionary *nameTypeDic = [self modelIvarNameAndIvarType:cls];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [nameTypeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [resultDic setValue:[self ivarTypeToSqliteTypeDic][obj] forKey:key];
    }];
    return resultDic;
}

+(NSString *)modelIvarNameAndSqliteTypeStr:(Class)cls{
    NSDictionary *dic = [self modelIvarNameAndSqliteType:cls];
    NSMutableArray *muArr = [NSMutableArray array];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *tmp = [NSString stringWithFormat:@"%@ %@",key,obj];
        [muArr addObject:tmp];
    }];
//    a interger, name2 text
    return [muArr componentsJoinedByString:@","];
}

+(NSArray *)modelIvarSortedNames:(Class)cls{
    NSDictionary *dic = [self modelIvarNameAndIvarType:cls];
    NSArray *columnNames = dic.allKeys;
    
    [columnNames sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return columnNames;
}

+(NSDictionary *)ivarTypeToSqliteTypeDic{
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
}
@end
