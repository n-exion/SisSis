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

@protocol AddScheduleDelegate
- (void) addedSchedule:(ScheduleData*)schedule;
@end


//EventKit
@interface AddScheduleViewController : UITableViewController<UITextFieldDelegate>{
  EditableCell* editableCell;
  WorkTimeDecideViewController* workTimeDecideController;
  DepartureDecideViewController* departureDecideViewController;
  
  NSDateFormatter* dateFormat;
  ScheduleData* schedule;
  
  EditableCell* titleCell;
  EditableCell* positionCell;
  
  id<AddScheduleDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet EditableCell* editableCell;
@property (strong, nonatomic) IBOutlet DoubleRowCell* doubleRowCell;
@property (strong, nonatomic) ScheduleData* schedule;

@property (strong, nonatomic) WorkTimeDecideViewController* workTimeDecideController;
@property (strong, nonatomic) DepartureDecideViewController* departureDecideViewController;

@property (strong, nonatomic) id<AddScheduleDelegate> delegate;

- (void) updateStartTime:(NSDate*)start;
- (void) updateEndTime:(NSDate*)end;
- (NSString*) convertDateToString:(NSDate*)date;
- (id)initWithDate:(NSDate*) now;


@end

