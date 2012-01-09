//
//  SisSisViewController.m
//  SisSis
//
//  Created by Naoki Egawa on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import "SisSisViewController.h"

@implementation SisSisViewController
@synthesize monthView;
@synthesize toolBar;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];

}


- (void)loadView
{
  [super loadView];
  // カレンダービュー初期化
  monthView = [[TKCalendarMonthView alloc] init];
  //CGRect frame = monthView.frame;
  //[monthView setCenter:CGPointMake(160.0, 44.0+frame.size.height/2)];
  [self.view addSubview:monthView];
  [monthView reload];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
  if (monthView != nil) [monthView release];
  [super dealloc];
}


@end
