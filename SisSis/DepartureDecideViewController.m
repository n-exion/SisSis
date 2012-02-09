//
//  MasterViewController.m
//  TestStartDecideView
//
//  Created by じょん たいたー on 12/01/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DepartureDecideViewController.h"
#import "DeparturePositionDecideViewController.h"

#import "UICGDirections.h"
#import "UICRouteAnnotation.h"

#import "AddScheduleViewController.h"
#import "ScheduleData.h"

#import "MapDirectionsViewController.h"
#import "ModalDatePickerViewController.h"
#import "MapDirectionsViewController.h"


@implementation DepartureDecideViewController

@synthesize travelModeSegment;
@synthesize departurePositionDecideViewController;
@synthesize arrivalTimeController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Master", @"Master");
  }
  
  sectionDictionary = [[[NSMutableDictionary alloc] init] autorelease] ;
  rowDictionary = [[[NSMutableDictionary alloc] init] autorelease];
  
  [sectionDictionary setObject:[NSNumber numberWithInt:1] forKey:@"DeparturePosition"];
  [rowDictionary setObject:[NSNumber numberWithInt:0] forKey:@"DeparturePosition"];
  [sectionDictionary setObject:[NSNumber numberWithInt:1] forKey:@"ArrivalPosition"];
  [rowDictionary setObject:[NSNumber numberWithInt:1] forKey:@"ArrivalPosition"];
  [sectionDictionary setObject:[NSNumber numberWithInt:2] forKey:@"DepartureTime"];
  [rowDictionary setObject:[NSNumber numberWithInt:0] forKey:@"DepartureTime"];
  [sectionDictionary setObject:[NSNumber numberWithInt:2] forKey:@"ArrivalTime"];
  [rowDictionary setObject:[NSNumber numberWithInt:1] forKey:@"ArrivalTime"];
  [sectionDictionary setObject:[NSNumber numberWithInt:2] forKey:@"StartTime"];
  [rowDictionary setObject:[NSNumber numberWithInt:2] forKey:@"StartTime"];
  
  return self;
}

- (void) setAddScheduleViewController:(AddScheduleViewController *)controller{
  addController = controller;
}

- (void)dealloc
{
  if(departurePositionDecideViewController){
    [departurePositionDecideViewController release];
  }
  [sectionDictionary release];
  [rowDictionary release];
  if(arrivalTimeController){
    [arrivalTimeController release];
  }
  [super dealloc];
}


//スケジュールデータとテーブルの内容を同期
- (void)syncTableWithScheduleData{
  ScheduleData* schedule = addController.schedule;
  
  NSInteger section = [[sectionDictionary objectForKey:@"DeparturePosition"] integerValue];
  NSInteger row = [[rowDictionary objectForKey:@"DeparturePosition"] integerValue];
  UITableViewCell* targetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
  targetCell.detailTextLabel.text = schedule.departurePosition;
  [targetCell setNeedsLayout];
  
  section = [[sectionDictionary objectForKey:@"StartTime"] integerValue];
  row = [[rowDictionary objectForKey:@"StartTime"] integerValue];
  targetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
  targetCell.detailTextLabel.text = [addController convertDateToString:schedule.startTime];
  [targetCell setNeedsLayout];

  //arrivalPositionの更新
  section = [[sectionDictionary objectForKey:@"ArrivalPosition"] integerValue];
  row = [[rowDictionary objectForKey:@"ArrivalPosition"] integerValue];
  targetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
  targetCell.detailTextLabel.text = schedule.arrivalPosition;
  [targetCell setNeedsLayout];
  
  //arrivalTimeの更新
  section = [[sectionDictionary objectForKey:@"ArrivalTime"] integerValue];
  row = [[rowDictionary objectForKey:@"ArrivalTime"] integerValue];
  targetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
  targetCell.detailTextLabel.text = [addController convertDateToString:schedule.arrivalTime];
  [targetCell setNeedsLayout];

  
  //departureTimeの更新
  section = [[sectionDictionary objectForKey:@"DepartureTime"] integerValue];
  row = [[rowDictionary objectForKey:@"DepartureTime"] integerValue];
  targetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];

  if(schedule.departureTime)
    targetCell.detailTextLabel.text = [addController convertDateToString:schedule.departureTime];
  else
    targetCell.detailTextLabel.text = @"を更新する";
  [targetCell setNeedsLayout];

}



- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch(section){
      //交通手段
    case 0:
      return 1;
      //出発地点, 到着地点
    case 1:
      return 2;
      //出発時刻, 到着時刻 (この出発時刻がぐるぐるする?)
    case 2:
      return 3;
      //経路詳細?
  }
  
  return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		travelModeSegment = [[[UISegmentedControl alloc] initWithItems:
                          [NSArray arrayWithObjects:NSLocalizedString(@"Driving", nil), 
                           /*NSLocalizedString(@"Train", nil), */
                           NSLocalizedString(@"Walking", nil), nil]] autorelease];
		[travelModeSegment setFrame:CGRectMake(9.0f, 0.0f, 302.0f, 45.0f)];
		travelModeSegment.selectedSegmentIndex = 0;

    [travelModeSegment addTarget:self action:@selector(changeTravelMode:) forControlEvents:UIControlEventValueChanged];

		[cell addSubview:travelModeSegment];
    
    return cell;
    
  }
  else if(indexPath.section == 1){
    static NSString *CellIdentifier = @"CellValue2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch(indexPath.row){
      case 0:
        cell.textLabel.text = NSLocalizedString(@"出発地点", nil);
        
        if (addController.schedule.departurePosition == nil){
          addController.schedule.departurePosition = @"自宅";
        }
        cell.detailTextLabel.text = addController.schedule.departurePosition;
        
        break;
      case 1:
        if(addController.schedule.arrivalPosition == nil){
          addController.schedule.arrivalPosition = addController.schedule.position;
        }

        cell.detailTextLabel.text = addController.schedule.arrivalPosition;
        cell.textLabel.text = NSLocalizedString(@"到着地点", nil);
        break;
    }
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.30f blue:0.49f alpha:1.0f];
    
    return cell;
    
  }
  
  else if(indexPath.section == 2){
    static NSString *CellIdentifier;
    
    if(indexPath.row == 0){
      CellIdentifier = @"CellValu2AI";
    }
    else{
      CellIdentifier = @"CellValue2";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    switch(indexPath.row){
      case 0:
      {
        searchIndicator = [[[UIActivityIndicatorView alloc] init] autorelease];
        searchIndicator.frame = CGRectMake(50, 0, 200,50);
        [searchIndicator startAnimating];
        
        [cell.contentView addSubview:searchIndicator];
        cell.textLabel.text = NSLocalizedString(@"出発時刻", nil);
        cell.detailTextLabel.text = @"を計算する";
        break;
      }
      case 1:
        cell.textLabel.text = NSLocalizedString(@"到着時刻", nil);

        if(addController.schedule.arrivalTime == nil){
          NSCalendar* calendar = [NSCalendar currentCalendar];
          NSDateComponents* diff = [[[NSDateComponents alloc] init] autorelease];
          diff.minute = -5;
          addController.schedule.arrivalTime = [calendar dateByAddingComponents:diff toDate:addController.schedule.startTime options:0];
          //addController.schedule.arrivalTime = addController.schedule.startTime;
        }

        cell.detailTextLabel.text = [addController convertDateToString:addController.schedule.arrivalTime];
        break;
        
      case 2:
        cell.textLabel.text = NSLocalizedString(@"開始時刻", nil);
        cell.detailTextLabel.text = [addController convertDateToString:addController.schedule.startTime];

        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        break;
    }
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.30f blue:0.49f alpha:1.0f];
    
    return cell;
    
  }
  
  return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //出発場所を決めるなら
  if(indexPath.section == 1 && indexPath.row == 0){
    if(!self.departurePositionDecideViewController){
      self.departurePositionDecideViewController = [[[DeparturePositionDecideViewController alloc] initWithNibName:@"DeparturePositionDecideViewController" bundle:nil] autorelease];
      [self.departurePositionDecideViewController setDeparturePositionDecideViewController:self];
      [self.departurePositionDecideViewController setAddScheduleViewController:addController];
    }
    
    [self.navigationController pushViewController:self.departurePositionDecideViewController animated:YES];
  }
  //検索開始が呼ばれたら
  if (indexPath.section == 2 && indexPath.row == 0) {
    MapDirectionsViewController* mapController;

    mapController = [[[MapDirectionsViewController alloc] initWithNibName:@"MapDirectionsViewController" bundle:nil] autorelease];
    mapController.addController = addController;
    mapController.departureController = self;
		
    mapController.travelMode = addController.schedule.travelMode;
		
		[self.navigationController pushViewController:mapController animated:YES];
  }
  
  if (indexPath.section == 2 && indexPath.row == 1) {
    if(!self.arrivalTimeController){
      self.arrivalTimeController = [[[ModalDatePickerViewController alloc] initWithNibName:@"ModalDatePickerViewController" bundle:nil] autorelease];
      self.arrivalTimeController.addMainController = addController;
      self.arrivalTimeController.departureController = self;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.75];
    [self.view addSubview:self.arrivalTimeController.view];
    [UIView commitAnimations];

	}
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

//loadWithStartPointを呼んで終わったらここになります
- (void) directionsDidUpdateDirections:(UICGDirections *)directions{
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
  

  NSString* durationSecondStr = [fmt stringForObjectValue:[directions.duration objectForKey:@"seconds"]];
  int second = [durationSecondStr intValue];
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* diff = [[[NSDateComponents alloc] init] autorelease];
  diff.second = -second;
  
  [searchIndicator stopAnimating];
  
  addController.schedule.departureTime= [calendar dateByAddingComponents:diff toDate:addController.schedule.arrivalTime options:0];
  
  [self syncTableWithScheduleData];

}

-(void) changeTravelMode : (UISegmentedControl*)seg{
  if (travelModeSegment.selectedSegmentIndex == 0) {
    addController.schedule.travelMode = UICGTravelModeDriving;
  } else {
    addController.schedule.travelMode = UICGTravelModeWalking;
  }
  
}

@end
