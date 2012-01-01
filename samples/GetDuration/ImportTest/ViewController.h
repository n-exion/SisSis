//
//  ViewController.h
//  ImportTest
//
//  Created by じょん たいたー on 11/12/31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "UICGDirections.h"


@interface ViewController : UIViewController<UICGDirectionsDelegate,MKMapViewDelegate>{
    MKMapView* routeMapView;
}

@property (retain, nonatomic) IBOutlet UIButton *updateButton;
@property (retain, nonatomic) IBOutlet UIView *mapView;
@property (retain, nonatomic) IBOutlet UILabel *durationText;
@property (retain, nonatomic) IBOutlet UITextField *fromText;
@property (retain, nonatomic) IBOutlet UITextField *destinationText;

@end
