//
//  YPTable.h
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/24.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPTable : NSObject

//获取表中的字段
+ (NSArray *)columnSortedNames:(NSString *)tableName uid:(NSString *)uid;


@end

NS_ASSUME_NONNULL_END
