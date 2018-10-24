//
//  YPSqliteModelProtocol.h
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YPSqliteModelProtocol <NSObject>

@required
+ (NSString *)primaryKey;

@optional
+ (NSArray *)ignoreColumnNames;
+ (NSDictionary *)renameNewKeyToOldKeyDic;

@end

NS_ASSUME_NONNULL_END
