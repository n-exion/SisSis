//
//  DayEventViewController.h
//  SisSis
//
//  Created by 直毅 江川 on 12/02/02.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SisSisAppDelegate.h"
#import "ExtendClasses.h"
#import "TapkuLibrary.h"
#import "EventRectView.h"
#import "DetailMapViewController.h"

@protocol CalSegControlDelegate;
@interface DayEventViewController : UIViewController <UIScrollViewDelegate, EventRectDelegate>
{
  UIToolbar *toolBar;
  UIBarButtonItem *todayButton;
  UISegmentedControl *segControl;
  UINavigationItem *navTitle;
  SisSisAppDelegate* appDelegate;
  UITableView *eventTableView;
  NSArray *keyArray;
  NSMutableArray *dataArray;
	NSMutableDictionary *dataDictionary;
  NSDate *nowDate;
  id <CalSegControlDelegate> delegate;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *todayButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (retain, nonatomic) id <CalSegControlDelegate> delegate;
@property (assign, nonatomic) NSDate* nowDate;

- (IBAction) changedSegmentedControlValue:(id)sender;
- (IBAction) didPushedTodayButton:(id)sender;
- (void) generateEventDataForStartDate:(NSDate*)start;
- (void) showEKEventViewController:(EKEvent*) event;
- (void) showDetailMapViewController:(RouteData *) route;
@end

@protocol CalSegControlDelegate
- (void) changedSegmentControlValue:(NSInteger)value;
@end