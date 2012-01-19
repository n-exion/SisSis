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

@interface SisSisViewController : TKCalendarMonthTableViewController <EKEventEditViewDelegate, EKEventViewDelegate>
{
  // カレンダービュー追加
  UIToolbar *toolBar;
  NSMutableArray *dataArray;
	NSMutableDictionary *dataDictionary;
  UIBarButtonItem *todayButton;
  UITableView *tableEventView;
  UISegmentedControl *segControl;
  EKEventStore* eventStore;
  SisSisAppDelegate* appDelegate;
  BOOL displayedEventView;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *todayButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic) NSMutableArray *dataArray;
@property (retain, nonatomic) NSMutableDictionary *dataDictionary;
@property (retain, nonatomic) UITableView  *tableEventView;
@property (retain, nonatomic) EKEventStore *eventStore;



- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end;
- (void) addEventData;
- (IBAction) didPushedTodayButton:(id)sender;
- (IBAction) changedSegmentedControlValue:(id)sender;
@end
