//
//  EventRectView.m
//  SisSis
//
//  Created by 直毅 江川 on 12/02/09.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "EventRectView.h"
#import "SisSisAppDelegate.h"

#define RADIUS 5.0

@implementation EventRectView
@synthesize eventArray;
@synthesize routeArray;
@synthesize eventRects;
@synthesize routeRects;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      //Initialization code
      appDelegate = (SisSisAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (id)initWithEvents:(NSArray*)array
{
  eventArray = array;
  self = [self initWithFrame:CGRectMake(0.0, 0.0, 320.0, 1250.0)];
  if (self) {
    // Initialization code
    routeRects = nil;
    eventRects = nil;
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
  if (eventRects) [eventRects release];
  if (routeRects) [routeRects release];
  if (routeArray) [routeArray release];
  eventRects = [[NSMutableArray alloc] init];
  routeRects = [[NSMutableArray alloc] init];
  routeArray = [[NSMutableArray alloc] init];
  for (event in eventArray) {
    CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.6, 1.0);
    CGContextSetRGBFillColor(context, 0.7, 0.7, 0.85, 1.0);
    if (event.allDay) {
    } else {
      int sm = ([event.startDate timeIntervalSinceDate:nowDate] / 60);
      int em = ([event.endDate timeIntervalSinceDate:nowDate] / 60);
      float width = 320.0 - 60.0;
      float x = 54.0;
      float y = 48 + 0.8 * sm;
      CGRect rect = CGRectMake(x, y, width, 0.8 * (em - sm));
      [eventRects addObject:[NSValue valueWithCGRect:rect]];
      CGContextFillStrokeRoundedRect(context, rect, 5.0) ;
      UITextView *utv_title = [[UITextView alloc] initWithFrame:CGRectMake(x + 3.0, y + 4.0 , width - 12.0, 16.0)];
      utv_title.opaque = NO;
      utv_title.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
      utv_title.text = event.title;
      utv_title.scrollEnabled = NO;
      utv_title.editable = NO;
      [self addSubview:utv_title];
      [utv_title release];
      NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
      [outputFormatter setDateFormat:@"hh:mm"];
      NSString *startTime = [outputFormatter stringFromDate:event.startDate];
      NSString *endTime = [outputFormatter stringFromDate:event.endDate];
      [outputFormatter release];
      UITextView *utv_time = [[UITextView alloc] initWithFrame:CGRectMake(x + 3.0, y + 20.0 , width - 12.0, 16.0)];
      utv_time.opaque = NO;
      utv_time.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
      utv_time.text = [NSString stringWithFormat:@"%@ 〜 %@", startTime, endTime];
      utv_time.editable = NO;
      utv_time.scrollEnabled = NO;
      [self addSubview:utv_time];
      [utv_time release];
      // 枠内部色指定
      CGContextSetRGBFillColor(context, 0.9, 0.6, 0.5, 1.0);
      CGContextSetRGBStrokeColor(context, 0.8, 0.4, 0.2, 1.0);
      RouteData *route = [appDelegate.dbManager getRouteFromId:event.eventIdentifier];
      if (!route.departureTime || !route.arrivalTime) continue;
      [routeArray addObject:route];
      sm = ([route.departureTime timeIntervalSinceDate:nowDate] / 60);
      em = ([route.arrivalTime timeIntervalSinceDate:nowDate] / 60);
      y = 48 + 0.8 * sm;
      rect = CGRectMake(x, y, width, 0.8 * (em - sm));
      [routeRects addObject:[NSValue valueWithCGRect:rect]];
      CGContextFillStrokeRoundedRect(context, rect, 5.0);
      outputFormatter = [[NSDateFormatter alloc] init];
      [outputFormatter setDateFormat:@"hh:mm"];
      startTime = [outputFormatter stringFromDate:route.departureTime];
      endTime = [outputFormatter stringFromDate:route.arrivalTime];
      [outputFormatter release];
      UITextView *routeTime = [[UITextView alloc] initWithFrame:CGRectMake(x + 3.0, y, width - 12.0, 16.0)];
      routeTime.opaque = NO;
      routeTime.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
      routeTime.text = [NSString stringWithFormat:@"%@ 〜 %@", startTime, endTime];
      routeTime.editable = NO;
      routeTime.scrollEnabled = NO;
      [self addSubview:routeTime];
      [routeTime release];
    }
  }
  if (delegate) {
    [delegate finishedRectDraw:[[eventRects objectAtIndex:0] CGRectValue]];
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
@end
