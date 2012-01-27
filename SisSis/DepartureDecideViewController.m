//
//  MasterViewController.m
//  TestStartDecideView
//
//  Created by じょん たいたー on 12/01/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DepartureDecideViewController.h"
#import "DeparturePositionDecideViewController.h"

@implementation DepartureData

@synthesize departureTime;
@synthesize departurePosition;
@synthesize arrivalTime;
@synthesize arrivalPosition;
@synthesize startTime;

@end

@implementation DepartureDecideViewController

@synthesize travelModeSegment;
@synthesize startPositionDecideViewController;
@synthesize departureData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Master", @"Master");
  }
  
  depatureData = [[DepartureData alloc] init];
  sectionDictionary = [[NSMutableDictionary alloc] init];
  rowDictionary = [[NSMutableDictionary alloc] init];
  dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"MM-dd hh:mm"];

  
  [sectionDictionary setObject:[NSNumber numberWithInt:1] forKey:@"DeparturePosition"];
  [rowDictionary setObject:[NSNumber numberWithInt:0] forKey:@"DeparturePosition"];
  [sectionDictionary setObject:[NSNumber numberWithInt:1] forKey:@"DeparturePosition"];
  [rowDictionary setObject:[NSNumber numberWithInt:1] forKey:@"DeparturePosition"];
  [sectionDictionary setObject:[NSNumber numberWithInt:2] forKey:@"DepartureTime"];
  [rowDictionary setObject:[NSNumber numberWithInt:0] forKey:@"DepartureTime"];
  [sectionDictionary setObject:[NSNumber numberWithInt:2] forKey:@"ArrivalTime"];
  [rowDictionary setObject:[NSNumber numberWithInt:1] forKey:@"ArrivalTime"];
  [sectionDictionary setObject:[NSNumber numberWithInt:2] forKey:@"StartTime"];
  [rowDictionary setObject:[NSNumber numberWithInt:2] forKey:@"StartTime"];
  



  
  return self;
}

- (void)dealloc
{
  [startPositionDecideViewController release];
  [departureData release];
  [sectionDictionary release];
  [rowDictionary release];
  [dateFormat release];
  [super dealloc];
}


//departureDataの代入とともにテーブルを更新する
- (void)updateDepartureData:(DepartureData *)new_departureData{
  self.departureData = new_departureData;
  
  NSInteger section = [[sectionDictionary objectForKey:@"DeparturePostion"] integerValue];
  NSInteger row = [[rowDictionary objectForKey:@"DeparturePostion"] integerValue];
  UITableViewCell* targetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
  targetCell.detailTextLabel.text = self.departureData.departurePosition;
  [targetCell setNeedsLayout];
  
  section = [[sectionDictionary objectForKey:@"StartTime"] integerValue];
  row = [[rowDictionary objectForKey:@"StartTime"] integerValue];
  targetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
  targetCell.detailTextLabel.text = [dateFormat stringFromDate:self.departureData.startTime];
  [targetCell setNeedsLayout];

  //arrivalPositionの更新
  section = [[sectionDictionary objectForKey:@"ArrivalPosition"] integerValue];
  row = [[rowDictionary objectForKey:@"ArrivalPosition"] integerValue];
  targetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
  targetCell.detailTextLabel.text = self.departureData.arrivalPosition;
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
        cell.detailTextLabel.text = @"具体的な場所";
        
        break;
      case 1:
        if(self.departureData.arrivalPosition){
          cell.detailTextLabel.text = self.departureData.arrivalPosition;
        }
        else{
          cell.detailTextLabel.text = @"具体的な場所";        
        }
        cell.textLabel.text = NSLocalizedString(@"到着地点", nil);

        break;
    }
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.30f blue:0.49f alpha:1.0f];
    
    return cell;
    
  }
  
  else if(indexPath.section == 2){
    static NSString *CellIdentifier = @"CellValue2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    switch(indexPath.row){
      case 0:
        cell.textLabel.text = NSLocalizedString(@"出発時刻", nil);
        cell.detailTextLabel.text = @"具体的な時間";
        break;
      case 1:
        cell.textLabel.text = NSLocalizedString(@"到着時刻", nil);
        cell.detailTextLabel.text = @"具体的な時間";
        break;
      case 2:
        cell.textLabel.text = NSLocalizedString(@"開始時刻", nil);
        
        if(self.departureData.startTime){
          cell.detailTextLabel.text = [dateFormat stringFromDate:self.departureData.startTime];
        }
        else{
          cell.detailTextLabel.text = @"具体的な時間";
        }
        
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //出発場所を決めるなら
  if(indexPath.section == 1 && indexPath.row == 0){
    if(!self.startPositionDecideViewController){
      self.startPositionDecideViewController = [[[DeparturePositionDecideViewController alloc] initWithNibName:@"DeparturePositionDecideViewController" bundle:nil] autorelease];
    }
    [self.navigationController pushViewController:self.startPositionDecideViewController animated:YES];
  }
}

@end
