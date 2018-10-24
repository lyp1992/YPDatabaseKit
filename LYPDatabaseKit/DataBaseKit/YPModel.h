//
//  YPModel.h
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPModel : NSObject

+(NSString *)tableName:(Class)cls;
+(NSString *)tmpTableName:(Class)cls;

//将模型属性类型转换成数据库支持的类型 (eg: name text)
+(NSDictionary *)modelIvarNameAndSqliteType:(Class)cls;

//获取模型属性 类型 (eg: name NSString)
+(NSDictionary *)modelIvarNameAndIvarType:(Class)cls;

//拼接数据库字段 (eg: a interger, name2 text)
+(NSString *)modelIvarNameAndSqliteTypeStr:(Class)cls;

//获取模型字段
+(NSArray *)modelIvarSortedNames:(Class)cls;

@end

NS_ASSUME_NONNULL_END
