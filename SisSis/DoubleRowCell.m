//
//  DoubleRowCell.m
//  SampleTableView2
//
//  Created by じょん たいたー on 12/01/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DoubleRowCell.h"
#import "AddScheduleViewController.h"

@implementation DoubleRowCell
@synthesize startTimeField;
@synthesize endTimeField;
@synthesize addController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTime:(NSDate*)startTime endTime:(NSDate*)endTime{
    self.startTimeField.text = [addController convertDateToString:startTime];
    self.endTimeField.text = [addController convertDateToString:endTime];
}

- (void)dealloc {
    [startTimeField release];
    [endTimeField release];
    [super dealloc];
}
@end
