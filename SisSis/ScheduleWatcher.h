//
//  ScheduleWatcher.h
//  SisSis
//
//  Created by じょん たいたー on 12/02/10.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

#import "SisSisAppDelegate.h"
#import "ExtendClasses.h"
#import "TapkuLibrary.h"
#import "EventRectView.h"

#import "UICGDirections.h"


@interface ScheduleWatcher : NSObject<MKMapViewDelegate, UICGDirectionsDelegate,CLLocationManagerDelegate>{
  NSArray* watchingEvents;
  
  UICGDirections *diretions;
  CLLocationManager *locationManager;
  CLLocationCoordinate2D currentLocation;

}


- (void) setDayTimer:(NSDate*) start;
- (void) setTodayTimer;

@end
