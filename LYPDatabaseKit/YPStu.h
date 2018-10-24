//
//  YPStu.h
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPSqliteModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface YPStu : NSObject<YPSqliteModelProtocol>

@property (nonatomic, assign) NSInteger stu_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double score3;

@property (nonatomic, assign) double score2;

@property (nonatomic, strong) NSArray *arr;

@end

NS_ASSUME_NONNULL_END
