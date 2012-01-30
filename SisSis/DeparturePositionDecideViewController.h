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

@interface DeparturePositionDecideViewController : UITableViewController{
  DepartureDecideViewController* departureDecideViewController;
  AddScheduleViewController* addController;
}

-(void) setDeparturePositionDecideViewController:(DepartureDecideViewController*)controller;
-(void) setAddScheduleViewController:(AddScheduleViewController*)controller;

@end
