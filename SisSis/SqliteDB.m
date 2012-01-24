//
//  SqliteDB.m
//  SisSis
//
//  Created by Naoki Egawa on 12/01/25.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "SqliteDB.h"


@implementation SqliteDB

-(void) initializeDatabaseIfNeeded {
  NSFileManager* fileManager = [NSFileManager defaultManager];
  NSError* error;
  
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDir = [paths objectAtIndex:0];
  NSString* flagPath = [documentsDir stringByAppendingPathComponent:DBFLAG];
  
  // dbflag file check
  if (![fileManager fileExistsAtPath:flagPath]) {
    NSString* dbpath = [SqliteDB getDatabaseFilePath];
    NSString* templateDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:BASEDB];
    
    // remove database file
    if([fileManager fileExistsAtPath:dbpath] == YES) {
      [fileManager removeItemAtPath:dbpath error:NULL];
    }
    
    // copy database file
    if (![fileManager copyItemAtPath:templateDBPath toPath:dbpath error:&error]) {
      [error localizedDescription];
      return;
    }
    
    // dbflag file create
    [fileManager createFileAtPath:flagPath contents:nil attributes:nil];
  }
  
}

+(NSString*) getDatabaseFilePath {
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDir = [paths objectAtIndex:0];
  return [documentsDir stringByAppendingPathComponent:DBPATH];
}


- (void)dealloc {
  [super dealloc];
}

@end