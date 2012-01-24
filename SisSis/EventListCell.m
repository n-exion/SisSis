//
//  EventListCellController.m
//  SisSis
//
//  Created by 直毅 江川 on 12/01/23.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "EventListCell.h"

@implementation EventListCell
@synthesize timeLabel;
@synthesize eventLabel;

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

- (void)dealloc
{
  [super dealloc];
}

@end

