//
//  EventRectView.m
//  SisSis
//
//  Created by 直毅 江川 on 12/02/09.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "EventRectView.h"

#define RADIUS 5.0

@implementation EventRectView
@synthesize eventArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithEvents:(NSArray*)array
{
  eventArray = array;
  self = [self initWithFrame:CGRectMake(0.0, 0.0, 320.0, 1250.0)];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  if (!eventArray || eventArray.count == 0) {
    return;
  }
  // 現在のコンテクストを取得
  CGContextRef context = UIGraphicsGetCurrentContext();
  // 枠線描画色指定
  CGContextSetRGBStrokeColor(context, 0.2, 0.2, 0.5, 1.0);
  // 枠内部色指定
  CGContextSetRGBFillColor(context, 0.6, 0.6, 0.8, 1.0);
  // 枠線太さ
  CGContextSetLineWidth(context, 2.0);
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  EKEvent *se = [eventArray objectAtIndex:0];
  NSString *nowDateStr = [dateFormatter stringFromDate:se.startDate];
  NSDate *nowDate = [dateFormatter dateFromString:nowDateStr];
  [dateFormatter release];
  EKEvent *event;
  for (event in eventArray) {
    int sm = ([event.startDate timeIntervalSinceDate:nowDate] / 60);
    int em = ([event.endDate timeIntervalSinceDate:nowDate] / 60);
    CGContextFillStrokeRoundedRect(context, 
                                   CGRectMake(54.0, 48.0 + 0.8 * sm, 320.0 - 60.0, 0.8 * (em - sm)), 
                                   5.0) ;
  }
}

void CGContextFillStrokeRoundedRect( CGContextRef context, CGRect rect, CGFloat radius )
{
  CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
  CGContextAddArcToPoint( context, CGRectGetMinX( rect ), CGRectGetMinY( rect ), CGRectGetMidX( rect ),CGRectGetMinY( rect ), radius );
  CGContextAddArcToPoint( context, CGRectGetMaxX( rect ), CGRectGetMinY( rect ), CGRectGetMaxX( rect ), CGRectGetMidY( rect ), radius );
  CGContextAddArcToPoint( context, CGRectGetMaxX( rect ), CGRectGetMaxY( rect ), CGRectGetMidX( rect ), CGRectGetMaxY( rect ), radius );
  CGContextAddArcToPoint( context, CGRectGetMinX( rect ), CGRectGetMaxY( rect ), CGRectGetMinX( rect ), CGRectGetMidY( rect ), radius );
  CGContextClosePath( context );
  CGContextDrawPath( context, kCGPathFillStroke );
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
