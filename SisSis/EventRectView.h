//
//  EventRectView.h
//  SisSis
//
//  Created by 直毅 江川 on 12/02/09.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface EventRectView : UIView
{
  NSArray *eventArray;
}

@property (retain, nonatomic) NSArray *eventArray;
- (id)initWithEvents:(NSArray*)array;
void CGContextFillStrokeRoundedRect( CGContextRef context, CGRect rect, CGFloat radius );
@end
