//
//  SisSisAppDelegate.m
//  SisSis
//
//  Created by 直毅 江川 on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import "SisSisAppDelegate.h"
#import "AddScheduleViewController.h"
#import "ScheduleData.h"
#import "RouteData.h"
#import "ScheduleWatcher.h"

#import "SisSisViewController.h"


@implementation SisSisAppDelegate

@synthesize window;
@synthesize navController;
@synthesize eventStore;
@synthesize dataArray;
@synthesize dataDictionary;
@synthesize dbManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.

  ssViewController = nil;
  eventStore = [[EKEventStore alloc] init];
  [self.window addSubview:self.navController.view];
  [self.window makeKeyAndVisible];
  // DBファイル初期化
  dbManager = [[DBManager alloc] init];
  
  scheduleWatcher = [[ScheduleWatcher alloc] init];
  [scheduleWatcher setTodayTimer];
  
  NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:
                              [scheduleWatcher methodSignatureForSelector:@selector(watchEvents)]];
  
  [invocation setTarget:scheduleWatcher];
  [invocation setSelector:@selector(watchEvents)];
  
  NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:10.0 invocation:invocation repeats:YES];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

- (void)dealloc
{
  [window release];
  [navController release];
  if (eventStore != nil) [eventStore release];
  [scheduleWatcher release];
  [super dealloc];
}

- (void) addEventToCalendar:(ScheduleData*)data {
  EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
  event.title = data.title;
  event.location = data.position;
  event.startDate = data.startTime;
  event.endDate = data.endTime;
  //event.notes = data.description;
  NSError *error = nil;
  // イベントが関連付けられるカレンダーを設定
  [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
  [self.eventStore saveEvent:event span:EKSpanThisEvent error:&error];
  // 経路情報をDBにも登録
  if (data.departurePosition && data.departureTime 
      && data.arrivalTime && data.arrivalPosition) {
    RouteData *route = [[RouteData alloc] init];
    route.identifier = event.eventIdentifier; 
    route.departurePosition = data.departurePosition;
    route.departureTime = data.departureTime;
    route.arrivalTime = data.arrivalTime;
    route.arrivalPosition = data.arrivalPosition;
    if (data.travelMode == UICGTravelModeDriving) {
      route.travelMode = 0;
    } else {
      route.travelMode = 1;
    }
    [dbManager addRoute:route];
    [route release];
  }
  NSLog(@"saved new Event");
}

// イベントハンドラども
- (IBAction)pushedAddButton:(id)sender{
  // ここで予定の追加の画面に遷移すればいいはず_egawa
  NSLog(@"pushed AddEventButton");
  NSDate* date = [self getSelectedDate];
  if (!date) {
    date = [NSDate date];
  }
  AddScheduleViewController* addView = [[[AddScheduleViewController alloc] initWithDate:date] autorelease];
  addView.delegate = self;
  [self.navController pushViewController:addView animated:YES];
}

- (void) getMonthViewController
{
  if (!ssViewController) {
    int count = self.navController.viewControllers.count;
    for (int i = 0; i < count; i++) {
      id vc = [navController.viewControllers objectAtIndex:i];
      if ([vc isKindOfClass:[SisSisViewController class]]) {
        ssViewController = vc;
        break;
      }
    }
  }
}

- (NSDate*) getSelectedDate
{
  [self getMonthViewController];
  if (ssViewController) {
    return [ssViewController.monthView dateSelected];
  }
  return nil;
}

- (void) addedSchedule:(ScheduleData*)schedule
{
  [self addEventToCalendar:schedule];
  [self getMonthViewController];
  if (ssViewController) {
    [ssViewController reload];
  }
}

@end
