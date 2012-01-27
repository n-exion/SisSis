//
//  MasterViewController.h
//  TestStartDecideView
//
//  Created by じょん たいたー on 12/01/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class DeparturePositionDecideViewController;


//出発情報をまとめたクラス
@interface DepartureData : NSObject{
  NSString* departurePosition;
  NSDate* departureTime;
  
  NSString* arrivalPosition;
  NSDate* arrivalTime;
  NSDate* startTime;

}

@property (strong,nonatomic) NSString* departurePosition;
@property (strong,nonatomic) NSDate* departureTime;
@property (strong,nonatomic) NSString* arrivalPosition;
@property (strong,nonatomic) NSDate* arrivalTime;
@property (strong,nonatomic) NSDate* startTime;


@end


@interface DepartureDecideViewController : UITableViewController{
	UISegmentedControl *travelModeSegment;
  DeparturePositionDecideViewController* departurePositionDecideViewController;
  DepartureData *departureData;
  
  NSMutableDictionary* sectionDictionary;
  NSMutableDictionary* rowDictionary;
  NSDateFormatter* dateFormat;
}

@property (strong, nonatomic) DeparturePositionDecideViewController *departurePositionDecideViewController;
@property (strong,nonatomic) UISegmentedControl* travelModeSegment;
@property (strong,nonatomic) DepartureData* departureData;

- (void) updateDepartureData:(DepartureData *)departureData;

@end