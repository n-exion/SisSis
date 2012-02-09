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
  direction_searching = NO;


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
  
  if(diretions.isInitialized){
    [self startSearchDirection];
  }
}

#pragma mark <UICGDirectionsDelegate> Methods
- (void)directionsDidFinishInitialize:(UICGDirections *)directions {
  [self startSearchDirection];
}

- (void)addWatchingEvent:(EKEvent*)event{
  [watchingEvents addObject:event];
}

-(void) startSearchDirection{
  SisSisAppDelegate* appDelegate = (SisSisAppDelegate*)[[UIApplication sharedApplication] delegate];
  DBManager* dbManager = appDelegate.dbManager;
  
  NSString* position = [NSString stringWithFormat:@"%f,%f",currentLocation.latitude,currentLocation.longitude];
  
  nearest_index = -1;
  NSDate* nearest = [NSDate date];
  NSDateComponents *dc  = [[NSDateComponents alloc] init];
  [dc setDay:1];
  nearest = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:nearest options:0];

  
  //starttimeが一番近い奴を監視
  for (int i = 0; i < [watchingEvents count];i++){
    EKEvent* e = [watchingEvents objectAtIndex:i];
    
    if([nearest compare:e.startDate] == NSOrderedDescending){
      nearest_index = i;
      nearest = e.startDate;
    }
  }
  
  if (nearest_index == -1)
    return;
  
  EKEvent* target = [watchingEvents objectAtIndex:nearest_index];
  RouteData* route = [dbManager getRouteFromId:target.eventIdentifier];
    
  //addController.schedule
  //空じゃないときだけやる気だす
  if(route.arrivalPosition != nil && ![route.arrivalPosition isEqualToString:@""]){
    if (direction_searching) {
      return;
    }
    UICGDirectionsOptions *options = [[[UICGDirectionsOptions alloc] init] autorelease];
    options.travelMode = route.travelMode;
    [diretions loadWithStartPoint:position endPoint:route.arrivalPosition options:options];
    direction_searching = YES;
  }
  else{
    NSDate* now = [NSDate date];
    if([now compare:target.startDate] == NSOrderedDescending){
      NSString* message = [NSString stringWithFormat:@"予定「%@」がオーバーしそうです",target.title];
      UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                                       message:message
                                                      delegate:self 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles: nil] autorelease];
      [alert show];
    }
    [watchingEvents removeObjectAtIndex:nearest_index];
  }
}


- (void)directionsDidUpdateDirections:(UICGDirections *)directions {
  EKEvent* target = [watchingEvents objectAtIndex:nearest_index];
  direction_searching = NO;

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
  NSNumberFormatter* fmt = [[[NSNumberFormatter alloc] init] autorelease];
  NSString* durationSecondStr = [fmt stringForObjectValue:[directions.duration objectForKey:@"seconds"]];
  int second = [durationSecondStr intValue];
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* diff = [[[NSDateComponents alloc] init] autorelease];
  //TODO ここに柔軟性を持たせる. 今は5分固定
  diff.second = second + 5 * 60;
  
  NSDate* now = [NSDate date];
  NSDate* arrive_date = [calendar dateByAddingComponents:diff toDate:now options:0];
 
  //時間すぎそう
  if([arrive_date compare:target.startDate] == NSOrderedDescending){
    NSString* message = [NSString stringWithFormat:@"予定「%@」がオーバーしそうです",target.title];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                                     message:message
                                                    delegate:self 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles: nil] autorelease];
    [alert show];
    [watchingEvents removeObjectAtIndex:nearest_index];

  }
  
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
  
  NSArray* today_events = [appDelegate.eventStore eventsMatchingPredicate:p];
  //watchingEvents = [[NSMutableArray alloc] initWithArray: ];
  watchingEvents = [[NSMutableArray alloc] init];


	//過ぎ去ったイベントは足さない. 邪悪な設定
  //TODO この辺、マジデモ用
  for (int i = 0; i < [today_events count];i++){

    EKEvent* e = [today_events objectAtIndex:i];
    //TODO: 本当はstartDateじゃないよ
    if([now compare:e.startDate] == NSOrderedDescending)
      continue;
    
    [watchingEvents addObject:e];
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
