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
#import "DBManager.h"

@class SisSisViewController;

@interface SisSisAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UINavigationController *navController;
  EKEventStore* eventStore;
  DBManager* dbManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableDictionary *dataDictionary;
@property (nonatomic, retain) EKEventStore *eventStore;

- (IBAction)pushedAddButton:(id)sender;
// 最終的には使わない
- (IBAction)pushedCalenderButton:(id)sender;

@end
