//
//  EventRectView.h
//  SisSis
//
//  Created by 直毅 江川 on 12/02/09.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
@protocol EventRectDelegate;
@interface EventRectView : UIView
{
  NSArray *eventArray;
  NSMutableArray *eventRects;
  id <EventRectDelegate> delegate;
}

@property (copy, nonatomic) NSArray *eventArray;
@property (copy, nonatomic) NSMutableArray *eventRects;
@property (retain, nonatomic) id <EventRectDelegate> delegate;
- (id)initWithEvents:(NSArray*)array;
void CGContextFillStrokeRoundedRect( CGContextRef context, CGRect rect, CGFloat radius );
@end

@protocol EventRectDelegate 
- (void) finishedRectDraw:(CGRect)rect;
@end