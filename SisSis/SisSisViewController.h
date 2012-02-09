//
//  SisSisViewController.h
//  SisSis
//
//  Created by Naoki Egawa on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "TapkuLibrary.h"
#import "SisSisAppDelegate.h"
#import "DayEventViewController.h"
#import "EventListViewController.h"

@class EventListViewController;
@interface SisSisViewController : TKCalendarMonthTableViewController 
<EKEventViewDelegate, CalSegControlDelegate>
{
  // カレンダービュー追加
  UIToolbar *toolBar;
  UIBarButtonItem *todayButton;
  UISegmentedControl *segControl;
  SisSisAppDelegate* appDelegate;
  NSMutableArray *dataArray;
	NSMutableDictionary *dataDictionary;
  dispatch_queue_t main_queue;
  dispatch_queue_t load_queue;
  id elvc_dialog;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *todayButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;

- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end;
- (void) addEventData;
- (void) reload;
- (IBAction) didPushedTodayButton:(id)sender;
- (IBAction) changedSegmentedControlValue:(id)sender;
@end
