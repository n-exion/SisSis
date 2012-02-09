//
//  ScheduleWatcher.h
//  SisSis
//
//  Created by じょん たいたー on 12/02/10.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SisSisAppDelegate.h"
#import "ExtendClasses.h"
#import "TapkuLibrary.h"
#import "EventRectView.h"




@interface ScheduleWatcher : NSObject{
  NSArray* watchingEvents;
}


- (void) setDayTimer:(NSDate*) start;
- (void) setTodayTimer;

@end
