//
//  MapDirectionsViewController.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "MapDirectionsViewController.h"
#import "UICRouteOverlayMapView.h"
#import "UICRouteAnnotation.h"
#import "RouteListViewController.h"


#import "AddScheduleViewController.h"
#import "DepartureDecideViewController.h"
#import "ScheduleData.h"


@implementation MapDirectionsViewController

@synthesize wayPoints;
@synthesize travelMode;
@synthesize locationManager;
@synthesize currentLocation;

@synthesize departureController;
@synthesize addController;

- (void)dealloc {
	[routeOverlayView release];
  [wayPoints release];
  [locationManager release];
  [super dealloc];
}

- (void)loadView {
	UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)] autorelease];
	self.view = contentView;

	routeMapView = [[MKMapView alloc] initWithFrame:contentView.frame];
	routeMapView.delegate = self;
	routeMapView.showsUserLocation = YES;
	[contentView addSubview:routeMapView];
	[routeMapView release];
	
	routeOverlayView = [[UICRouteOverlayMapView alloc] initWithMapView:routeMapView];
	
	UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	UIBarButtonItem *currentLocationButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reticle.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moveToCurrentLocation:)] autorelease];
	UIBarButtonItem *mapPinButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map_pin.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addPinAnnotation:)] autorelease];
	UIBarButtonItem *routesButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showRouteListView:)] autorelease];
    
	self.toolbarItems = [NSArray arrayWithObjects:currentLocationButton, space, mapPinButton, routesButton, nil];
	[self.navigationController setToolbarHidden:NO animated:NO];
	
	diretions = [UICGDirections sharedDirections];
	diretions.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  ScheduleData* schedule = addController.schedule;
  BOOL useGPS = NO;
  
  if([schedule.departurePosition isEqualToString:@"現在地点"]  || 
     [ schedule.arrivalPosition isEqualToString:@"現在地点" ]){
    useGPS = YES;
  }
  else{
    if (diretions.isInitialized) {
      [self update];
    }
    return;
  }
  
  if(useGPS){
    if(![CLLocationManager locationServicesEnabled]){
      UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                                       message:@"目的地を入力してください"
                                                      delegate:self 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles: nil] autorelease];
      [alert show];
      
    }
    else{
      locationManager = [[CLLocationManager alloc] init];
      locationManager.delegate = self;
      
      //位置情報の取得を開始
      [locationManager startUpdatingLocation];
    }

  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)update {
    //シングルトンからオブジェクトを取得する
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	UICGDirectionsOptions *options = [[[UICGDirectionsOptions alloc] init] autorelease];
	options.travelMode = travelMode;

  [diretions loadWithStartPoint:addController.schedule.departurePosition endPoint:addController.schedule.arrivalPosition options:options];

}

- (void)moveToCurrentLocation:(id)sender {
	[routeMapView setCenterCoordinate:[routeMapView.userLocation coordinate] animated:YES];
}

- (void)addPinAnnotation:(id)sender {
	UICRouteAnnotation *pinAnnotation = [[[UICRouteAnnotation alloc] initWithCoordinate:[routeMapView centerCoordinate]
																				  title:nil
																		 annotationType:UICRouteAnnotationTypeWayPoint] autorelease];
	[routeMapView addAnnotation:pinAnnotation];
}

- (void)showRouteListView:(id)sender {
	RouteListViewController *controller = [[RouteListViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.routes = diretions.routes;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
	[self presentModalViewController:navigationController animated:YES];
	[controller release];
	[navigationController release];
}

#pragma mark <UICGDirectionsDelegate> Methods

- (void)directionsDidFinishInitialize:(UICGDirections *)directions {
	[self update];
}

- (void)directions:(UICGDirections *)directions didFailInitializeWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Map Directions" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alertView show];
	[alertView release];
}

- (void)directionsDidUpdateDirections:(UICGDirections *)directions {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	// Overlay polylines
	UICGPolyline *polyline = [directions polyline];
	NSArray *routePoints = [polyline routePoints];
	[routeOverlayView setRoutes:routePoints];
	
	// Add annotations
	UICRouteAnnotation *startAnnotation = [[[UICRouteAnnotation alloc] initWithCoordinate:[[routePoints objectAtIndex:0] coordinate]    
                                                                                    title:addController.schedule.departurePosition
																		   annotationType:UICRouteAnnotationTypeStart] autorelease];
	UICRouteAnnotation *endAnnotation = 
    [[[UICRouteAnnotation alloc] initWithCoordinate:[
                                                     [routePoints lastObject] coordinate]
                                              title:addController.schedule.arrivalPosition
                                     annotationType:UICRouteAnnotationTypeEnd] autorelease];
	if ([wayPoints count] > 0) {
		NSInteger numberOfRoutes = [directions numberOfRoutes];
		for (NSInteger index = 0; index < numberOfRoutes; index++) {
			UICGRoute *route = [directions routeAtIndex:index];
			CLLocation *location = [route endLocation];
			UICRouteAnnotation *annotation = [[[UICRouteAnnotation alloc] initWithCoordinate:[location coordinate]
																					   title:[[route endGeocode] objectForKey:@"address"]
																			  annotationType:UICRouteAnnotationTypeWayPoint] autorelease];
			[routeMapView addAnnotation:annotation];
		}
	}
  
  NSNumberFormatter* fmt = [[[NSNumberFormatter alloc] init] autorelease];
  NSString* durationSecondStr = [fmt stringForObjectValue:[directions.duration objectForKey:@"seconds"]];
  int second = [durationSecondStr intValue];
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* diff = [[[NSDateComponents alloc] init] autorelease];
  diff.second = -second;
    
  addController.schedule.departureTime = [calendar dateByAddingComponents:diff toDate:addController.schedule.arrivalTime options:0];
  [departureController syncTableWithScheduleData];

		
	[routeMapView addAnnotations:[NSArray arrayWithObjects:startAnnotation, endAnnotation, nil]];
}

- (void)directions:(UICGDirections *)directions didFailWithMessage:(NSString *)message {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Map Directions" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alertView show];
	[alertView release];
}

#pragma mark <MKMapViewDelegate> Methods

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	routeOverlayView.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	routeOverlayView.hidden = NO;
	[routeOverlayView setNeedsDisplay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	static NSString *identifier = @"RoutePinAnnotation";
	
	if ([annotation isKindOfClass:[UICRouteAnnotation class]]) {
		MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		if(!pinAnnotation) {
			pinAnnotation = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
		}
		
		if ([(UICRouteAnnotation *)annotation annotationType] == UICRouteAnnotationTypeStart) {
			pinAnnotation.pinColor = MKPinAnnotationColorGreen;
		} else if ([(UICRouteAnnotation *)annotation annotationType] == UICRouteAnnotationTypeEnd) {
			pinAnnotation.pinColor = MKPinAnnotationColorRed;
		} else {
			pinAnnotation.pinColor = MKPinAnnotationColorPurple;
		}
		
		pinAnnotation.animatesDrop = YES;
		pinAnnotation.enabled = YES;
		pinAnnotation.canShowCallout = YES;
		return pinAnnotation;
	} else {
		return [routeMapView viewForAnnotation:routeMapView.userLocation];
	}
}

#pragma mark <CLLocationManagerDelegate> Methods
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
  // 位置情報更新
  currentLocation = newLocation.coordinate;
	//_longitude = newLocation.coordinate.longitude;
	//_latitude = newLocation.coordinate.latitude;
  NSLog([NSString stringWithFormat:@"long:%f lat:%f",currentLocation.longitude,currentLocation.latitude]);
  
  [locationManager stopUpdatingLocation];
  
  if (diretions.isInitialized) {
    //addController.schedule
    NSString* position = [NSString stringWithFormat:@"%f,%f",currentLocation.latitude,currentLocation.longitude];
    
    if([addController.schedule.departurePosition isEqualToString:@"現在地点"]){
      addController.schedule.departurePosition = position;
    }
    if([addController.schedule.arrivalPosition isEqualToString:@"現在地点"]){
      addController.schedule.arrivalPosition = position;
    }

		[self update];
	}
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"位置情報が取得できませんでした。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
  [alertView show];
  [alertView release];
}

@end
