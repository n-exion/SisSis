//
//  StartPositionDecideViewController.h
//  TestStartDecideView
//
//  Created by じょん たいたー on 12/01/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DepartureDecideViewController;
@class AddScheduleViewController;
@class ButtonEditableCell;

@interface DeparturePositionDecideViewController : UITableViewController{
  DepartureDecideViewController* departureDecideViewController;
  AddScheduleViewController* addController;
  NSMutableArray* positionList;
}

@property (strong, nonatomic) IBOutlet ButtonEditableCell* buttonEditableCell;

-(void) setDeparturePositionDecideViewController:(DepartureDecideViewController*)controller;
-(void) setAddScheduleViewController:(AddScheduleViewController*)controller;

@end
