//
//  SisSisViewController.h
//  SisSis
//
//  Created by Naoki Egawa on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapkuLibrary.h"

@interface SisSisViewController : TKCalendarMonthTableViewController {
  // カレンダービュー追加
  UIToolbar *toolBar;
  NSMutableArray *dataArray;
	NSMutableDictionary *dataDictionary;
  UIBarButtonItem *todayButton;
  UITableView *tableEventView;
  UISegmentedControl *segControl;
  BOOL displayedEventView;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *todayButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain,nonatomic) NSMutableArray *dataArray;
@property (retain,nonatomic) NSMutableDictionary *dataDictionary;
@property UITableView  *tableEventView;

- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end;
- (IBAction) didPushedTodayButton:(id)sender;
- (IBAction) changedSegmentedControlValue:(id)sender;
@end
