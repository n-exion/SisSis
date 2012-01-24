//
//  AccountModel.m
//  SisSis
//
//  Created by 直毅 江川 on 12/01/25.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "AccountModel.h"
#import "SqliteDB.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"


@implementation AccountModel

@synthesize recordId, gender, userName;

-(id) init {
  [super init];
  recordId = -1;
  return self;
}

+(int) countAll {
  NSString* dbPath = [SqliteDB getDatabaseFilePath];
  NSString* sql1 = [NSString stringWithFormat:@"select count(*) as count from Account"];
  
  FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
  if(![db open]) {
    return 0;
  }
  [db setShouldCacheStatements:YES];
  
  FMResultSet* rs = nil;
  rs = [db executeQuery:sql1];
  
  int count = 0;
  if ([rs next]) {
    // just print out what we've got in a number of formats.
    count = [rs intForColumn:@"count"];
  }
  
  [rs close];
  [db close];
  
  return count;
}

/**
 *    select all
 */
+(NSMutableArray*)selectAll {
  NSString* dbPath = [SqliteDB getDatabaseFilePath];
  NSString* sql1 = [NSString stringWithFormat:@"select * from Account order by userName, gender, id"];
  NSMutableArray* ret = [[[NSMutableArray alloc] init] autorelease];
  
  FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
  if(![db open]) {
    return nil;
  }
  [db setShouldCacheStatements:YES];
  
  FMResultSet* rs = nil;
  rs = [db executeQuery:sql1];
  
  while ([rs next]) {
    AccountModel* account = [AccountModel createAccountModel:rs];
    [ret addObject:account];
  }
  
  [rs close];
  [db close];
  
  return ret;
}

/**
 * select by id
 */
+(AccountModel*)selectById:(int)recordId {
  NSString* dbPath = [SqliteDB getDatabaseFilePath];
  NSString* sql = [NSString stringWithFormat:@"select * from Account where id = ?"];
  
  FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
  if(![db open]) {
    return nil;
  }
  [db setShouldCacheStatements:YES];
  
  FMResultSet* rs = nil;
  rs = [db executeQuery:sql, [NSNumber numberWithInt:recordId]];
  
  AccountModel* account = nil;
  if ([rs next]) {
    account = [AccountModel createAccountModel:rs];
  }
  
  [rs close];
  [db close];
  
  return account;
}

+(AccountModel*) createAccountModel:(FMResultSet*)rs {
  AccountModel* account = [[[AccountModel alloc] init] autorelease];
  
  account.recordId = [rs intForColumn:@"id"];
  account.gender = [rs intForColumn:@"gender"];
  account.userName = [rs stringForColumn:@"userName"];
  
  return account;
}

/**
 *    save record
 */
+(int) saveId:(int)recordId gender:(int)gender userName:(NSString*)userName {
  NSString* dbPath = [SqliteDB getDatabaseFilePath];
  NSString* sql = [NSString stringWithFormat:@"%@%@",
                   @"insert or replace into Account (id, gender, userName)",
                   @" values (?, ?, ?)"];
  
  FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
  if(![db open]) {
    return -1;
  }
  [db setShouldCacheStatements:YES];
  
  if (recordId == -1) {
    [db executeUpdate:sql, [NSNull null], [NSNumber numberWithInt:gender], userName];
  } else {
    [db executeUpdate:sql, [NSNumber numberWithInt:recordId], [NSNumber numberWithInt:gender], userName];
  }
  
  int lastInsertRowId = [db lastInsertRowId];
  [db close];
  
  return lastInsertRowId;
}

+(void) deleteId:(int)recordId {
  NSString* dbPath = [SqliteDB getDatabaseFilePath];
  NSString* sql = @"delete from Account where id = ?";
  
  FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
  if(![db open]) {
    return;
  }
  [db setShouldCacheStatements:YES];
  
  [db executeUpdate:sql, [NSNumber numberWithInt:recordId]];
  
  [db close];
}

- (void)dealloc {
  [userName release];
  [super dealloc];
}

@end