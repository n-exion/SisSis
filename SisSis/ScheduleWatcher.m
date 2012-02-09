//
//  ScheduleWatcher.m
//  SisSis
//
//  Created by じょん たいたー on 12/02/10.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>

#import "ScheduleWatcher.h"
#import "TapkuLibrary.h"


//予定がせまってきたらアラーム(イベント詳細画面)を発するクラス
@implementation ScheduleWatcher
- (ScheduleWatcher*)init{
  self = [super init];
  


  return self;
}

//時間的にやばい予定が無いか調べる
//数十分に1回これが呼ばれる感じで
- (void)watchEvents{
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  
  //位置情報の取得を開始
  [locationManager startUpdatingLocation];
}

#pragma mark <CLLocationManagerDelegate> Methods
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
  // 位置情報更新
  [locationManager stopUpdatingLocation];
  currentLocation = newLocation.coordinate;
	//_longitude = newLocation.coordinate.longitude;
	//_latitude = newLocation.coordinate.latitude;
  diretions = [UICGDirections sharedDirections];
  diretions.delegate = self;
}

#pragma mark <UICGDirectionsDelegate> Methods

- (void)directionsDidFinishInitialize:(UICGDirections *)directions {
  SisSisAppDelegate* appDelegate = (SisSisAppDelegate*)[[UIApplication sharedApplication] delegate];
  DBManager* dbManager = appDelegate.dbManager;
  
  NSString* position = [NSString stringWithFormat:@"%f,%f",currentLocation.latitude,currentLocation.longitude];
  
  for (int i = 0; i < [watchingEvents count];i++){
    EKEvent* e = [watchingEvents objectAtIndex:i];
    RouteData* route = [dbManager getRouteFromId:e.eventIdentifier];
    
    //addController.schedule
    UICGDirectionsOptions *options = [[[UICGDirectionsOptions alloc] init] autorelease];
    options.travelMode = route.travelMode;
    
    [diretions loadWithStartPoint:position endPoint:route.arrivalPosition options:options];

  }

}


- (void)directionsDidUpdateDirections:(UICGDirections *)directions {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	// Overlay polylines
	UICGPolyline *polyline = [directions polyline];
	NSArray *routePoints = [polyline routePoints];
	
  NSNumberFormatter* fmt = [[[NSNumberFormatter alloc] init] autorelease];
  NSString* durationSecondStr = [fmt stringForObjectValue:[directions.duration objectForKey:@"seconds"]];
  int second = [durationSecondStr intValue];
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* diff = [[[NSDateComponents alloc] init] autorelease];
  diff.second = -second;
  
  //addController.schedule.departureTime = [calendar dateByAddingComponents:diff toDate:addController.schedule.arrivalTime options:0];
  //[departureController syncTableWithScheduleData];
  
  
	//[routeMapView addAnnotations:[NSArray arrayWithObjects:startAnnotation, endAnnotation, nil]];
}



- (void) setTodayTimer{
  NSDate* today = [NSDate date];
  
  NSCalendar* calendar = [NSCalendar currentCalendar];
  //１時間足すよう

  NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                            fromDate:today];
  
  NSDate* start = [calendar dateFromComponents:dateComps];

  [self setDayTimer: start];
}

- (void) timerControl:(NSTimer*)timer{

  NSString* eventIndex = (NSString*)[[timer userInfo] objectForKey:@"eventIndex"];

  EKEvent* e = [watchingEvents objectAtIndex:[eventIndex intValue]];
  
  
  NSLog([NSString stringWithFormat: @"start event %@",e.title]);
  //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}





//指定された日のタイマーをセット
- (void) setDayTimer:(NSDate*) start{
  NSDate* now = [NSDate date];
  SisSisAppDelegate* appDelegate = (SisSisAppDelegate*)[[UIApplication sharedApplication] delegate];

  
  EKCalendar *cal = [appDelegate.eventStore defaultCalendarForNewEvents];
  NSDateComponents *dc  = [[NSDateComponents alloc] init];
  [dc setDay:1];
  NSDate *end = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:start options:0];
  [dc release];
  NSPredicate *p = [appDelegate.eventStore predicateForEventsWithStartDate:start endDate:end calendars:[NSArray arrayWithObject:cal]];
  watchingEvents = [appDelegate.eventStore eventsMatchingPredicate:p];
  [watchingEvents retain];
	
  for (int i = 0; i < [watchingEvents count];i++){

    EKEvent* e = [watchingEvents objectAtIndex:i];
    //TODO: 本当はstartDateじゃないよ
    if([now compare:e.startDate] == NSOrderedDescending)
      continue;
    //RouteData* route = [dbManager getRouteFromId:e.eventIdentifier];
    NSString* index = [NSString stringWithFormat:@"%d",i];
    
    NSDictionary *userInfoDictionary =[NSDictionary dictionaryWithObjectsAndKeys:
                                       index,@"eventIndex",nil];

    NSTimer* timer = [[[NSTimer alloc] initWithFireDate:e.startDate
                                              interval:1.0 
                                                target:self 
                                              selector:@selector(timerControl:) 
                                              userInfo:userInfoDictionary
                                                repeats:NO] autorelease];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

  }

}

@end
