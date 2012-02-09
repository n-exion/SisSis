//
//  EventListViewController.h
//  SisSis
//
//  Created by 直毅 江川 on 12/01/23.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapkuLibrary.h"
#import "SisSisAppDelegate.h"
#import "EventListCell.h"
#import "SisSisViewController.h"
#import "DayEventViewController.h"

@interface EventListViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, EKEventViewDelegate>
{
  UIToolbar *toolBar;
  UIBarButtonItem *todayButton;
  UISegmentedControl *segControl;
  SisSisAppDelegate* appDelegate;
  UITableView *eventTableView;
  BOOL loadingKeyArray;
  id <CalSegControlDelegate> delegate;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *todayButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic) IBOutlet UITableView *eventTableView;
@property BOOL loadingKeyArray;
@property (retain, nonatomic) id <CalSegControlDelegate> delegate;

- (IBAction) changedSegmentedControlValue:(id)sender;
- (IBAction) didPushedTodayButton:(id)sender;
- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end;
- (void) initKeyArray;
@end