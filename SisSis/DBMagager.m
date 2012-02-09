//
//  SisSisSqlite.m
//  SisSis
//
//  Created by 直毅 江川 on 12/02/04.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "DBManager.h"
#import "RouteData.h"

#define DB_FILE_NAME @"SisSis.db"

#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS routes (id TEXT PRIMARY KEY, departurePosition TEXT, departureTime REAL, arrivalPosition TEXT, arrivalTime REAL, travelMode INTEGER);"
#define SQL_INSERT @"INSERT INTO routes (id, departurePosition, departureTime, arrivalPosition, arrivalTime, travelMode) VALUES (?, ?, ?, ?, ?, ?);"
#define SQL_UPDATE @"UPDATE routes SET departurePosition = ?, departureTime = ?, arrivalPosition = ?, arrivalTime = ?, travelMode = ? WHERE id = ?;"
#define SQL_SELECT @"SELECT id, departurePosition, departureTime, arrivalPosition, arrivalTime, travelMode FROM routes;"
#define SQL_SELECT_ID @"SELECT departurePosition, departureTime, arrivalPosition, arrivalTime, travelMode FROM routes WHERE id = ?;"
#define SQL_DELETE @"DELETE FROM routes WHERE id = ?;"

@implementation DBManager
@synthesize dbPath;

- (id)init
{
	self = [super init];
	if( self )
	{
		FMDatabase *db = [self getConnection];
		[db open];
		[db executeUpdate:SQL_CREATE];
		[db close];
	}
	return self;
}

/**
 * 経路を追加します。
 *
 * @param route 経路
 *
 * @return BOOL
 */
- (BOOL)addRoute:(RouteData *)route
{
	FMDatabase* db = [self getConnection];
	[db open];
  
	[db setShouldCacheStatements:YES];
	if( [db executeUpdate:SQL_INSERT, route.identifier, route.departurePosition, route.departureTime, route.arrivalPosition, route.arrivalTime, route.travelMode] )
	{
    [db close];
		return YES;
	}
	
	[db close];
	return NO;
}

/**
 * 経路コレクションを取得します。
 *
 * @return 経路コレクション。
 */
- (NSArray *)getRoutes
{
	FMDatabase* db = [self getConnection];
	[db open];
	
	FMResultSet*    results = [db executeQuery:SQL_SELECT];
	NSMutableArray* routes = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	while( [results next] )
	{
    RouteData* route = [[RouteData alloc] init];
		route.identifier        = [results stringForColumnIndex:0];
		route.departurePosition = [results stringForColumnIndex:1];
		route.departureTime     = [results dateForColumnIndex:2];
		route.arrivalPosition   = [results stringForColumnIndex:3];
		route.arrivalTime       = [results dateForColumnIndex:4];
    route.travelMode        = [results intForColumnIndex:5];
		
		[routes addObject:route];
		[route release];
	}
	
	[db close];
	
	return routes;
}

/**
 * identifierから経路を取得します。
 *
 * @return 経路データ
 */
- (RouteData *)getRouteFromId:(NSString *)identifier
{
	FMDatabase* db = [self getConnection];
	[db open];
	
	FMResultSet*    results = [db executeQuery:SQL_SELECT_ID, identifier];
	RouteData* route = [[[RouteData alloc] init] autorelease];

  while ([results next]) {
    route.identifier = identifier;
    route.departurePosition = [results stringForColumnIndex:0];
    route.departureTime     = [results dateForColumnIndex:1];
    route.arrivalPosition   = [results stringForColumnIndex:2];
    route.arrivalTime       = [results dateForColumnIndex:3];
    route.travelMode        = [results intForColumnIndex:4];
  }
	
	[db close];
	
	return route;
}

/**
 * 経路情報を削除します。
 *
 * @param eventIdentifier
 *
 * @return 成功時は YES。それ以外は NO。
 */
- (BOOL)removeRoute:(NSInteger)eventId
{
	FMDatabase* db = [self getConnection];
	[db open];
  
	BOOL isSucceeded = [db executeUpdate:SQL_DELETE, [NSNumber numberWithInteger:eventId]];
	
	[db close];
  
	return isSucceeded;
}

/**
 * 書籍を更新します。
 */
- (BOOL)updateRoute:(RouteData *)route
{
	FMDatabase* db = [self getConnection];
	[db open];
	
	BOOL isSucceeded = [db executeUpdate:SQL_UPDATE, route.departurePosition, route.departureTime,
                      route.arrivalPosition, route.arrivalTime, route.travelMode, route.identifier];
	
	[db close];
	
	return isSucceeded;
}

/**
 * データベースを取得します。
 *
 * @return データベース。
 */
- (FMDatabase *)getConnection
{
	if( self.dbPath == nil )
	{
		self.dbPath =  [DBManager getDbFilePath];
	}
	
	return [FMDatabase databaseWithPath:self.dbPath];
}

/**
 * データベース ファイルのパスを取得します。
 */
+ (NSString*)getDbFilePath
{
	NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* dir   = [paths objectAtIndex:0];
	
	return [dir stringByAppendingPathComponent:DB_FILE_NAME];
}
@end
