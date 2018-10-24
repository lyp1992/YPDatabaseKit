//
//  YPSqliteModelTool.m
//  LYPDatabaseKit
//
//  Created by laiyp on 2018/10/23.
//  Copyright © 2018 laiyongpeng. All rights reserved.
//

#import "YPSqliteModelTool.h"
#import "YPModel.h"
#import "YPSqliteTool.h"
#import "YPTable.h"

@implementation YPSqliteModelTool


+(BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid{
    
    Class cls = [model class];
//   1. 判断是否存在这个表
    if (![self isTableExists:cls uid:uid]) {
        
       [self createTable:cls uid:uid];
    }
    
//   2. 判断是否需要更新
    if ([self isTableRequiredUpdate:cls uid:uid]) {
        [self updateTable:cls uid:uid];
    }
    
//   3. 判断记录是否存在，存在更新
    NSString *tableName = [YPModel tableName:cls];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要使用这个框架, 操作你的模型, 必须要实现+ (NSString *)primaryKey;");
        return NO;
    }
//      3.1 获取当前model 在表中是否存在
    NSString *primaryKey = [cls primaryKey];
    id primaryKeyValue = [model valueForKeyPath:primaryKey];
    NSString *rowExists = [NSString stringWithFormat:@"select *from %@ where %@=%@",tableName,primaryKey,primaryKeyValue];
    NSArray *rows = [YPSqliteTool querySql:rowExists uid:uid];
    
    NSArray *columnNames = [YPModel modelIvarNameAndIvarType:cls].allKeys;//获取所有的属性
    NSMutableArray *columnNameValues = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        id value = [model valueForKeyPath:columnName];
        [columnNameValues addObject:value];
    }
    
    if (rows.count>1) {
//        3.2 存在 -更新
        NSInteger count = columnNames.count;
        NSMutableArray *setArray = [NSMutableArray array];
        for (int i = 0; i< count; i++) {
            NSString *columnName = columnNames[i];
            id value = columnNameValues[i];
//            字段 = 字段值
            NSString *setStr = [NSString stringWithFormat:@"%@='%@'",columnName,value];
            [setArray addObject:setStr];
        }
    
//        3.2.1 拼接更新字段
//          字段1=字段1值，字段2=字段2值
        NSString *setStrResult = [setArray componentsJoinedByString:@","];
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ where %@='%@'",tableName,setStrResult,primaryKey,primaryKeyValue];
        return [YPSqliteTool dealWithSql:updateSql uid:uid];
    }
    
//   4. 如果记录不存在，插入
//    insert into 表名（字段1，字段2...）values ('字段1值'，‘字段2值’...)
    NSString *columnStr = [columnNames componentsJoinedByString:@","];
    NSString *columnValueStr = [columnNameValues componentsJoinedByString:@"\',\'"];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@) values ('%@')",tableName,columnStr,columnValueStr];
    
    return [YPSqliteTool dealWithSql:insertSql uid:uid];
}

// 0.删除某一个模型
+(BOOL)deleteModel:(id)model uid:(NSString *)uid{
    
    Class cls = [model class];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要使用这个框架, 操作你的模型, 必须要实现+ (NSString *)primaryKey;");
        return NO;
    }
    
    NSString *primaryKey = [cls primaryKey];
    id primaryKeyValue = [model valueForKeyPath:primaryKey];
    
    return [self deleteModels:cls key:primaryKey relation:RelationTypeEqual value:primaryKeyValue uid:uid];
}

// 1.删除所有的模型
+(BOOL)deleteAllModel:(Class)cls uid:(NSString *)uid{
    NSString *tableName = [YPModel tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"delete from %@",tableName];
    return [YPSqliteTool dealWithSql:sql uid:uid];
}

// 2.根据某一个条件 ，去批量删除模型 sql
+(BOOL)deleteModels:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid{
    NSString *tableName = [YPModel tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"delete from %@",tableName];
    if (whereStr.length > 0) {
        sql = [sql stringByAppendingFormat:@"where %@",whereStr];
    }
    return [YPSqliteTool dealWithSql:sql uid:uid];
}

// 2.1 根据某一个条件 ，去批量删除模型
+(BOOL)deleteModels:(Class)cls key:(NSString *)key relation:(RelationType)relation value:(id)value uid:(NSString *)uid{
    NSString *tableName = [YPModel tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ %@ '%@'",tableName,key,[self ralationToStr][@(relation)],value];
    return [YPSqliteTool dealWithSql:sql uid:uid];
}


#pragma mark -- search
+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid{
    NSString *tableName = [YPModel tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"select *from %@",tableName];
    NSArray<NSDictionary *>*results = [YPSqliteTool querySql:sql uid:uid];
    return [self handleResults:results toModelClass:cls];
}
+ (NSArray *)queryModels:(Class)cls key:(NSString *)key relation:(RelationType)relation value:(id)value uid:(NSString *)uid{
    NSString *tableName = [YPModel tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ %@ '%@'", tableName, key, [self ralationToStr][@(relation)], value];
    
    NSArray <NSDictionary *>*results = [YPSqliteTool querySql:sql uid:uid];
    return [self handleResults:results toModelClass:cls];
    
}
+ (NSArray *)queryModels:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid
{
    NSString *tableName = [YPModel tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@", tableName, whereStr];
    
    NSArray <NSDictionary *>*results = [YPSqliteTool querySql:sql uid:uid];
    return [self handleResults:results toModelClass:cls];
}

+ (NSArray *)queryModels:(Class)cls querySQL:(NSString *)sql uid:(NSString *)uid{
    NSArray <NSDictionary *>*results = [YPSqliteTool querySql:sql uid:uid];
    return [self handleResults:results toModelClass:cls];
}

#pragma mark --privite Method

//字典转模型
+ (NSArray *)handleResults:(NSArray <NSDictionary *>*)results toModelClass:(Class)cls{
    NSMutableArray *modelR = [NSMutableArray array];
    NSDictionary *ivarNameTypeDic = [YPModel modelIvarNameAndIvarType:cls];
    //    rowDic {列名1 =列值，列2= 列2值} ivarNameTypeDic {name = NSString,age = NSInteger}
    for (NSDictionary *rowDic in results) {
        
        id model = [[cls alloc]init];
        [modelR addObject:model];
        
        [rowDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull columnName, id  _Nonnull value, BOOL * _Nonnull stop) {
           // 对value<进行处理(这一列对应的类型, 是数组/字典)
            NSString *type = ivarNameTypeDic[columnName];
            id tmpValue = value;
            if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
                NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error;
                tmpValue = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error) {
                    NSLog(@"%@",error.localizedDescription);
                }
            }else if ([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]){
                NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
                // NSJSONReadingMutableContainers 可变容器
                // 0 解析出来的集合, 是不可变
                tmpValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
            }
            
            [model setValue:tmpValue forKeyPath:columnName];
        }];
    }
    return modelR;
}

+ (NSDictionary *)ralationToStr {
    
    return @{
             @(RelationTypeGreater): @">",
             @(RelationTypeLess): @"<",
             @(RelationTypeEqual): @"=",
             @(RelationTypeGreaterEqual): @">=",
             @(RelationTypeLessEqual): @"<=",
             @(RelationTypeNotEqual): @"!="
             };
    
}

+(BOOL)isTableExists:(Class)cls uid:(NSString *)uid{
    
    NSString *tableName = [YPModel tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"select *from sqlite_master where type='table' and name = '%@'",tableName];
    NSArray *reulsts = [YPSqliteTool querySql:sql uid:uid];
    
    return reulsts.count > 1;
}

+(BOOL)createTable:(Class)modelClass uid:(NSString *)uid{
   
//    根据模型获取表名
    NSString *tableName = [YPModel tableName:modelClass];
    
//    根据模型创建b表字段
    NSString *nameTypeStr = [YPModel modelIvarNameAndSqliteTypeStr:modelClass];
    
    if (![modelClass respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要使用这个框架, 操作你的模型, 必须要实现+ (NSString *)primaryKey;");
        return NO;
    }
    NSString *primaryKey = [modelClass primaryKey];
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(%@,primary key (%@))",tableName,nameTypeStr,primaryKey];
    return [YPSqliteTool dealWithSql:sql uid:uid];
}

+(BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid{
    
//    获取模型字段
    NSArray *modelNames = [YPModel modelIvarSortedNames:cls];
    
//    获取数据库表字段
    NSArray *tableModelNames = [YPTable columnSortedNames:[YPModel tableName:cls] uid:uid];
    
    return ![modelNames isEqualToArray:tableModelNames];
    
}

+(BOOL)updateTable:(Class)cls uid:(NSString *)uid{
    
    NSMutableArray *sqls = [NSMutableArray array];
//    1.创建临时表
//      1.1 创建临时表名
    NSString *tmpTableName = [YPModel tmpTableName:cls];
    NSString *oldTableName = [YPModel tableName:cls];
//      1.2 根据模型属性创建sql字符串
    NSString *tmpSql = [YPModel modelIvarNameAndSqliteTypeStr:cls];
//      1.3 创建表
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果要使用这个框架，必须实现primaryKey");
        return NO;
    }
    NSString * primaryKey = [cls primaryKey];
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(%@,primary key (%@));",tmpTableName,tmpSql,primaryKey];
    [sqls addObject:sql];
    
//    2.将旧表中的数据挪到x临时表中
//      2.1 按照主键，插入数据到临时表
     // insert into YPStu_tmp(stu_id) select stu_id from YPStu;
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@(%@) select (%@) from %@;",tmpTableName,primaryKey,primaryKey,oldTableName];
    [sqls addObject:insertSql];
    
//      2.2 根据主键，将旧表数据n更新到临时表
    // update YPStu_tmp set name = (select name from YPStu where YPStu.stu_id = YPStu_tmp.stu_id);
    // update 临时表格名称 set 新字段名称 = (select 旧的字段名称 from 旧的表格 where 旧的表格.主键 = 临时表格名称.主键);
    NSDictionary *renameDic = [NSDictionary dictionary];
    if ([cls respondsToSelector:@selector(renameNewKeyToOldKeyDic)]) {
        renameDic = [cls renameNewKeyToOldKeyDic];
    }
    NSArray *newColumnNames = [YPModel modelIvarSortedNames:cls];
    NSArray *oldColumnNames = [YPTable columnSortedNames:oldTableName uid:uid];
    for (NSString *newColumnName in newColumnNames) {
        
        NSString *oldName = [renameDic valueForKey:newColumnName];
        if (oldName.length == 0 || ![oldColumnNames containsObject:oldName]) {
            oldName = newColumnName;
        }
        if ((![oldColumnNames containsObject:newColumnName] && ![oldColumnNames containsObject:oldName]) || [newColumnName isEqualToString:primaryKey]) {
            continue;
        }
        NSString *updateInsertSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@);",tmpTableName,newColumnName,oldName,oldTableName,oldTableName,primaryKey,tmpTableName,primaryKey];
        
        [sqls addObject:updateInsertSql];
    }
    
//    3.删除旧表
    NSString *deleteSql = [NSString stringWithFormat:@"drop table if exists %@",oldTableName];
    [sqls addObject:deleteSql];
    
//    4.修改临时表的名称
    NSString *renameSql = [NSString stringWithFormat:@"alter table %@ rename to %@;",tmpTableName,oldTableName];
    [sqls addObject:renameSql];
    
    [YPSqliteTool dealWithSqls:sqls uid:uid];
    
    return YES;
}


@end
