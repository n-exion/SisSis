//
//  ViewController.m
//  ImportTest
//
//  Created by じょん たいたー on 11/12/31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "UICGDirections.h"
#import "UICRouteAnnotation.h"

@implementation ViewController
@synthesize updateButton;
@synthesize mapView;
@synthesize durationText;
@synthesize fromText;
@synthesize destinationText;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//これを自分で定義するとviewを自分で作らなくてはならない？？
/*
- (void)loadView{
    UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)] autorelease];
	self.view = contentView;
    
	routeMapView = [[MKMapView alloc] initWithFrame:contentView.frame];
	routeMapView.delegate = self;
	routeMapView.showsUserLocation = YES;
	[contentView addSubview:routeMapView];
	[routeMapView release];
	
    //routeOverlayView = [[UICRouteOverlayMapView alloc] initWithMapView:routeMapView];
    //diretions = [UICGDirections sharedDirections];
    //diretions.delegate = self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *contentView = mapView;
    
	routeMapView = [[[MKMapView alloc] initWithFrame:contentView.bounds] autorelease];
	routeMapView.delegate = self;
	routeMapView.showsUserLocation = YES;
	[contentView addSubview:routeMapView];
}


- (IBAction)updateMap:(id)sender {
    //NSString* startPoint = @"大岡山";
    //NSString* endPoint = @"大阪";
    NSString* startPoint = fromText.text;
    NSString* endPoint = destinationText.text;
    
    UICGDirections *directions = [UICGDirections sharedDirections];
    directions.delegate = self;
    UICGDirectionsOptions* options = [[[UICGDirectionsOptions alloc] init] autorelease];
    options.travelMode = UICGTravelModeDriving; //UICGTravelModeWalking
    
    [directions loadWithStartPoint:startPoint endPoint:endPoint options:options];
    //[directions loadWithStartPoint:@"New York" endPoint:@"Mexico" options:options];

}

//loadWithStartPointを呼んで終わったらここになります
- (void) directionsDidUpdateDirections:(UICGDirections *)directions{
    NSString* startPoint = fromText.text;
    NSString* endPoint = destinationText.text;

    UICGPolyline *polyline = [directions polyline];
    NSArray* routePoints = [polyline routePoints];
    
    //Add annotations
    UICRouteAnnotation *startAnnotation = 
    [[[UICRouteAnnotation alloc] initWithCoordinate:[[routePoints objectAtIndex:0] coordinate]
                                              title:startPoint
                                     annotationType:UICRouteAnnotationTypeStart] autorelease];
    
    UICRouteAnnotation *endAnnotation = 
    [[[UICRouteAnnotation alloc] initWithCoordinate:[[routePoints lastObject] coordinate]
                                              title:endPoint
                                     annotationType:UICRouteAnnotationTypeEnd] autorelease];
    
    [routeMapView addAnnotations:[NSArray arrayWithObjects:startAnnotation,endAnnotation,nil]];
    
    NSNumberFormatter* fmt = [[[NSNumberFormatter alloc] init] autorelease];

    /*
    NSArray* keys = [directions.distance allKeys];
    NSArray* values = [directions.distance allValues];
    //NSLog([keys objectAtIndex:0]);
    //NSLog([fmt stringForObjectValue:[values objectAtIndex:0]]);
    NSLog([fmt stringForObjectValue:[directions.distance objectForKey:@"meters"]]);
    
    NSArray* keys2 = [directions.duration allKeys];
    NSLog([keys2 objectAtIndex:0]);
     */
    
    NSLog([fmt stringForObjectValue:[directions.duration objectForKey:@"seconds"]]);
    NSString* durationSecondStr = [fmt stringForObjectValue:[directions.duration objectForKey:@"seconds"]];
    
    durationText.text = [NSString stringWithFormat:@"%@から%@までにかかる時間は%@秒です",startPoint,endPoint,durationSecondStr];
}

- (IBAction)hiddenKeyboard:(id)sender {
    [fromText resignFirstResponder];

}

- (IBAction)hiddenKeyboard2:(id)sender {
    [destinationText resignFirstResponder];
}


- (void)viewDidUnload
{
    [self setUpdateButton:nil];
    [self setMapView:nil];
    [self setDurationText:nil];
    [self setFromText:nil];
    [self setDestinationText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [updateButton release];
    [mapView release];
    [durationText release];
    [fromText release];
    [destinationText release];
    [super dealloc];
}
@end
