//
//  StartPositionDecideViewController.h
//  TestStartDecideView
//
//  Created by じょん たいたー on 12/01/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DepartureDecideViewController;

@interface DeparturePositionDecideViewController : UITableViewController{
  DepartureDecideViewController* departureDecideViewController;
}

-(void) setDeparturePositionDecideViewController:(DepartureDecideViewController*)controller;

@end
