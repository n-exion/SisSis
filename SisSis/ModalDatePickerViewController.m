//
//  ModalDatePickerViewController.m
//  SisSis
//
//  Created by じょん たいたー on 12/02/04.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "ModalDatePickerViewController.h"
#import "AddScheduleViewController.h"
#import "ScheduleData.h"

@implementation ModalDatePickerViewController
@synthesize submitButton;
@synthesize datePicker;
@synthesize addMainController;
@synthesize departureController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }

  
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  datePicker.datePickerMode = UIDatePickerModeTime;
  //TODO: タイミング的にaddMainControllerがnilになる可能性がゼロではない？
  datePicker.date = addMainController.schedule.arrivalTime;
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  [self setSubmitButton:nil];
  [self setDatePicker:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) pushDecideButton:(id)sender{
  [self.view removeFromSuperview];
}

- (IBAction)setAlerm{
  self.addMainController.schedule.arrivalTime = datePicker.date;
  [departureController syncTableWithScheduleData];
}



- (void)dealloc {
  [submitButton release];
  [datePicker release];
  [super dealloc];
}



@end
