//
//  DoubleRowCell.h
//  SampleTableView2
//
//  Created by じょん たいたー on 12/01/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddScheduleViewController;

@interface DoubleRowCell : UITableViewCell{
  AddScheduleViewController* addController;
    
}

@property (retain, nonatomic) IBOutlet UILabel *startTimeField;
@property (retain, nonatomic) IBOutlet UILabel *endTimeField;
@property (weak, nonatomic) AddScheduleViewController* addController;

- (void) setTime:(NSDate*)startTime endTime:(NSDate*)endDate;

@end
