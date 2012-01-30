//
//  MasterViewController.h
//  SampleTableView2
//
//  Created by じょん たいたー on 12/01/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved
//

#import <UIKit/UIKit.h>
#import "EditableCell.h"
#import "DoubleRowCell.h"
#import "WorkTimeDecideViewController.h"
#import "DepartureDecideViewController.h"

@class ScheduleData;

//EventKit
@interface AddScheduleViewController : UITableViewController<UITextFieldDelegate>{
  EditableCell* editableCell;
  WorkTimeDecideViewController* workTimeDecideController;
  DepartureDecideViewController* departureDecideViewController;
  
  NSDateFormatter* dateFormat;
  ScheduleData* schedule;
  
  EditableCell* titleCell;
  EditableCell* positionCell;
}

@property (strong, nonatomic) IBOutlet EditableCell* editableCell;
@property (strong, nonatomic) IBOutlet DoubleRowCell* doubleRowCell;
@property (strong, nonatomic) ScheduleData* schedule;

@property (strong) WorkTimeDecideViewController* workTimeDecideController;
@property (strong) DepartureDecideViewController* departureDecideViewController;

- (void) updateStartTime:(NSDate*)start;
- (void) updateEndTime:(NSDate*)end;
- (NSString*) convertDateToString:(NSDate*)date;

@end
