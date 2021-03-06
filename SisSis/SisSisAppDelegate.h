//
//  SisSisAppDelegate.h
//  SisSis
//
//  Created by Naoki Egawa on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "AddScheduleViewController.h"
#import "DBManager.h"


@class SisSisViewController;
@class ScheduleWatcher;

@interface SisSisAppDelegate : NSObject <UIApplicationDelegate, AddScheduleDelegate>
{
  UIWindow *window;
  UINavigationController *navController;
  EKEventStore* eventStore;
  SisSisViewController *ssViewController;
  DBManager* dbManager;
  ScheduleWatcher* scheduleWatcher;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableDictionary *dataDictionary;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, readonly, retain) DBManager* dbManager;

- (IBAction)pushedAddButton:(id)sender;
- (NSDate*) getSelectedDate;
// 最終的には使わない
//- (IBAction)pushedCalenderButton:(id)sender;

@end
