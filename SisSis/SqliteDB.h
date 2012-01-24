//
//  SqliteDB.h
//  SisSis
//
//  Created by Naoki Egawa on 12/01/25.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define BASEDB @"sample.sqlite"
#define DBPATH @"sampledata.sqlite"
#define DBFLAG @"dbflag"

@interface SqliteDB : NSObject

-(void) initializeDatabaseIfNeeded;

+(NSString*) getDatabaseFilePath;

@end
