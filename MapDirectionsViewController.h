//
//  MapDirectionsViewController.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UICGDirections.h"
#import <CoreLocation/CoreLocation.h>


@class UICRouteOverlayMapView;
@class DepartureDecideViewController;
@class AddScheduleViewController;

@interface MapDirectionsViewController : UIViewController<MKMapViewDelegate, UICGDirectionsDelegate,CLLocationManagerDelegate> {
	MKMapView *routeMapView;
	UICRouteOverlayMapView *routeOverlayView;
	UICGDirections *diretions;
	NSArray *wayPoints;
	UICGTravelModes travelMode;
  CLLocationManager *locationManager;
  
  DepartureDecideViewController* departureController;
  AddScheduleViewController* addController;
  CLLocationCoordinate2D currentLocation;
}

@property (nonatomic, retain) NSArray *wayPoints;
@property (nonatomic) UICGTravelModes travelMode;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocation;

@property (nonatomic,weak) DepartureDecideViewController* departureController;
@property (nonatomic,weak) AddScheduleViewController* addController;
- (void)update;

@end
