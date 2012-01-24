//
//  AccountModel.h
//  SisSis
//
//  Created by 直毅 江川 on 12/01/25.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"


@interface AccountModel : NSObject {
  int recordId;
  int gender;
  NSString* userName;
}

@property (nonatomic, readwrite) int recordId;
@property (nonatomic, readwrite) int gender;
@property (nonatomic, readwrite, retain) NSString* userName;

+(NSMutableArray*)selectAll;
+(int) countAll;
+(AccountModel*)selectById:(int)recordId;
+(int) saveId:(int)recordId gender:(int)gender userName:(NSString*)userName;
+(void) deleteId:(int)recordId;

// local
+(AccountModel*) createAccountModel:(FMResultSet*)rs;

@end