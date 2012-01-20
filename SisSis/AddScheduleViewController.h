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
#import "StartTimeDecideViewController.h"

//EventKit
@interface AddScheduleViewController : UITableViewController{
  EditableCell* editableCell;
  WorkTimeDecideViewController* workTimeDecideController;
  StartTimeDecideViewController* startTimeDecideController;
  
  NSDate* startTime;
  NSDate* endTime;
}

@property (strong, nonatomic) IBOutlet EditableCell* editableCell;
@property (strong, nonatomic) IBOutlet DoubleRowCell* doubleRowCell;

@property (strong) WorkTimeDecideViewController* workTimeDecideController;
@property (strong) StartTimeDecideViewController* startTimeDecideController;
@property (strong) NSDate* startTime;
@property (strong) NSDate* endTime;

- (void) updateStartTime:(NSDate*)start;
- (void) updateEndTime:(NSDate*)end;

@end
