//
//  YPSqliteTool.h
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPSqliteTool : NSObject
+(BOOL)dealWithSql:(NSString *)sql uid:(NSString *)uid;

+(BOOL)dealWithSqls:(NSArray *)sqls uid:(NSString *)uid;
//查询一条记录
+(NSArray <NSDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid;
@end

NS_ASSUME_NONNULL_END
