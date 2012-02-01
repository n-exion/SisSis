//
//  EventListViewController.h
//  SisSis
//
//  Created by 直毅 江川 on 12/01/23.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SisSisAppDelegate.h"
#import "EventListCell.h"

@interface EventListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
  UIToolbar *toolBar;
  UIBarButtonItem *todayButton;
  UISegmentedControl *segControl;
  SisSisAppDelegate* appDelegate;
  UITableView *eventTableView;
  NSArray *keyArray;
  NSDate *nowDate;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *todayButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic) IBOutlet UITableView *eventTableView;
@property (retain, nonatomic) NSArray *keyArray;
@property (retain, nonatomic) NSDate *nowDate;

- (IBAction) changedSegmentedControlValue:(id)sender;
- (IBAction) didPushedTodayButton:(id)sender;
- (void) initKeyArray;
@end
