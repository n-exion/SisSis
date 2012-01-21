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
}

@property (strong,nonatomic) NSString* departurePosition;
@property (strong,nonatomic) NSDate* departureTime;
@property (strong,nonatomic) NSString* arrivalPosition;
@property (strong,nonatomic) NSDate* arrivalTime;


@end


@interface DepartureDecideViewController : UITableViewController{
	UISegmentedControl *travelModeSegment;
  DeparturePositionDecideViewController* startPositionDecideViewController;
  DepartureData *depatureData;
}

@property (strong, nonatomic) DeparturePositionDecideViewController *startPositionDecideViewController;
@property (strong,nonatomic) UISegmentedControl* travelModeSegment;

@end
