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
@class ModalDatePickerViewController;

@interface DepartureDecideViewController : UITableViewController<UICGDirectionsDelegate,MKMapViewDelegate>{
	UISegmentedControl *travelModeSegment;
  DeparturePositionDecideViewController* departurePositionDecideViewController;
    
  NSMutableDictionary* tableSectionDictionary;
  NSMutableDictionary* tableRowDictionary;
  
  AddScheduleViewController* addController;
  UIActivityIndicatorView* searchIndicator;
  ModalDatePickerViewController* arrivalTimeController;
}

@property (strong, nonatomic) DeparturePositionDecideViewController *departurePositionDecideViewController;
@property (strong,nonatomic) UISegmentedControl* travelModeSegment;
@property (strong,nonatomic) ModalDatePickerViewController* arrivalTimeController;

-(void) setAddScheduleViewController:(AddScheduleViewController*) controller;
-(void) syncTableWithScheduleData;
-(void) changeTravelMode : (UISegmentedControl*)seg;


@end
