//
//  SisSisSqlite.h
//  SisSis
//
//  Created by 直毅 江川 on 12/02/04.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "RouteData.h"

@interface DBManager : NSObject {
}

- (BOOL)addRoute:(RouteData *)route;
- (NSArray *)getRoutes;
- (RouteData *)getRouteFromId:(NSString *)identifier;
- (BOOL)removeRoute:(NSInteger)eventId;
- (BOOL)updateRoute:(RouteData *)route;
- (FMDatabase*)getConnection;
+ (NSString*)getDbFilePath;

@property (nonatomic, copy) NSString* dbPath; //! データベース　ファイルへのパス

@end
