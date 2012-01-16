//
//  DoubleRowCell.h
//  SampleTableView2
//
//  Created by じょん たいたー on 12/01/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleRowCell : UITableViewCell{
    
}

@property (retain, nonatomic) IBOutlet UILabel *startTimeField;
@property (retain, nonatomic) IBOutlet UILabel *endTimeField;

- (void) setTime:(NSDate*)startTime endTime:(NSDate*)endDate;

@end
