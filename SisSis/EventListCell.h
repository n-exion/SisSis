//
//  EventListCellController.h
//  SisSis
//
//  Created by 直毅 江川 on 12/01/23.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListCell : UITableViewCell {
  UILabel *timeLabel;
  UILabel *eventLabel;
}

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *eventLabel;
@end
