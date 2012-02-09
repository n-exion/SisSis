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


@class UICRouteOverlayMapView;
@class DepartureDecideViewController;
@class AddScheduleViewController;

@interface DetailMapViewController : UIViewController<MKMapViewDelegate, UICGDirectionsDelegate> {
	MKMapView *routeMapView;
	UICRouteOverlayMapView *routeOverlayView;
	UICGDirections *diretions;
	UICGTravelModes travelMode;
  
  NSString* from;
  NSString* to;
}


@property (nonatomic, retain) NSString* from;
@property (nonatomic, retain) NSString* to;


- (DetailMapViewController*)initFrom:(NSString*)from To:(NSString*)to;


@end
