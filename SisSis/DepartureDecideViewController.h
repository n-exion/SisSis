//
//  MasterViewController.h
//  TestStartDecideView
//
//  Created by じょん たいたー on 12/01/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "UICGDirections.h"



@class DetailViewController;
@class DeparturePositionDecideViewController;
@class AddScheduleViewController;

@interface DepartureDecideViewController : UITableViewController<UICGDirectionsDelegate,MKMapViewDelegate>{
	UISegmentedControl *travelModeSegment;
  DeparturePositionDecideViewController* departurePositionDecideViewController;
  
  NSMutableDictionary* sectionDictionary;
  NSMutableDictionary* rowDictionary;
  
  AddScheduleViewController* addController;
}

@property (strong, nonatomic) DeparturePositionDecideViewController *departurePositionDecideViewController;
@property (strong,nonatomic) UISegmentedControl* travelModeSegment;

-(void) setAddScheduleViewController:(AddScheduleViewController*) controller;
-(void) syncTableWithScheduleData;

@end
