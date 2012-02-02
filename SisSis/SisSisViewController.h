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
#import "EventListViewController.h"
#import "DayEventViewController.h"

@interface SisSisViewController : TKCalendarMonthTableViewController 
<EKEventEditViewDelegate, EKEventViewDelegate, CalSegControlDelegate>
{
  // カレンダービュー追加
  UIToolbar *toolBar;
  UIBarButtonItem *todayButton;
  UISegmentedControl *segControl;
  SisSisAppDelegate* appDelegate;
  NSMutableArray *dataArray;
	NSMutableDictionary *dataDictionary;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *todayButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;

- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end;
- (void) addEventData;
- (IBAction) didPushedTodayButton:(id)sender;
- (IBAction) changedSegmentedControlValue:(id)sender;
@end
