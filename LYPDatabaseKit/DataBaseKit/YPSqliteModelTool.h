//
//  YPSqliteModelTool.h
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPSqliteModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,RelationType){
    RelationTypeGreater,// '>'
    RelationTypeLess,//'<'
    RelationTypeEqual,//'='
    RelationTypeGreaterEqual,//'>='
    RelationTypeLessEqual,//'<='
    RelationTypeNotEqual// '!='
};

@interface YPSqliteModelTool : NSObject

+(BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;

// 0.删除某一个模型
+(BOOL)deleteModel:(id)model uid:(NSString *)uid;

// 1.删除所有的模型
+(BOOL)deleteAllModel:(Class)cls uid:(NSString *)uid;

// 2.根据某一个条件 ，去批量删除模型 sql
+(BOOL)deleteModels:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;

// 2.1 根据某一个条件 ，去批量删除模型
+(BOOL)deleteModels:(Class)cls key:(NSString *)key relation:(RelationType)relation value:(id)value uid:(NSString *)uid;

// 查询所有
+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;
+ (NSArray *)queryModels:(Class)cls key:(NSString *)key relation:(RelationType)relation value:(id)value uid:(NSString *)uid;
+ (NSArray *)queryModels:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;

+ (NSArray *)queryModels:(Class)cls querySQL:(NSString *)sql uid:(NSString *)uid;



//+(BOOL)isTableExists:(Class)cls uid:(NSString *)uid;
//
//+(BOOL)createTable:(Class)modelClass uid:(NSString *)uid;
//
////判断是否需要更新
//+(BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;
//
////更新表格
//+(BOOL)updateTable:(Class)cls uid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
