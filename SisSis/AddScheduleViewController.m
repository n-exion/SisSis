//
//  MasterViewController.m
//  SampleTableView2
//
//  Created by じょん たいたー on 12/01/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddScheduleViewController.h"
#import "DoubleRowCell.h"
#import "DepartureDecideViewController.h"



@implementation AddScheduleViewController

@synthesize editableCell;
@synthesize doubleRowCell;
@synthesize workTimeDecideController;
@synthesize departureDecideViewController;


@synthesize startTime;
@synthesize endTime;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"予定の追加";
  }
  
  //NSLog([NSString stringWithFormat:@"StartCount:%d",[listTableObj count]]);
  //時刻の初期化処理
  NSDate* now = [NSDate date];
  NSCalendar* calendar = [NSCalendar currentCalendar];
  
  //１時間足すよう
  NSDateComponents* diff = [[[NSDateComponents alloc] init] autorelease];
  diff.hour = 1;
  
  NSDateComponents *dateComps = [calendar components:NSMinuteCalendarUnit
                                            fromDate:now];
  
  diff.minute = -dateComps.minute;
  
  self.startTime = [calendar dateByAddingComponents:diff toDate:now options:0];
  
  diff.hour = 2;
  self.endTime = [calendar dateByAddingComponents:diff toDate:now options:0];
  
  dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"MM-dd hh:mm"];

  
  return self;
}

- (void) updateStartTime:(NSDate*)start{
  self.startTime = start;
  
  DoubleRowCell* doubleCell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
  doubleCell.startTimeField.text = [dateFormat stringFromDate:start];
  [doubleCell setNeedsLayout];
}

- (void) updateEndTime:(NSDate*)end{
  self.endTime = end;
  
  DoubleRowCell* doubleCell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
  doubleCell.endTimeField.text = [dateFormat stringFromDate:end];
  [doubleCell setNeedsLayout];
}


- (void)dealloc
{
  [editableCell release];
  [workTimeDecideController release];
  [departureDecideViewController release];
  [dateFormat release];
  [super dealloc];
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
  [self setEditableCell:nil];
  [self setEditableCell:nil];
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
// 超ハードコーディング?
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if(section == 0){
    return 2;
  }
  else if(section == 1){
    return 1;
  }
  else if(section == 2){
    return 1;
  }
  
  return -1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  switch(indexPath.section){
    case 0:
      return 47.0f;
    case 1:
      return 69.0f;
      
    case 2:
      return 47.0f;
  }
  return 0.0f;
}

- (EditableCell*) createEditableCell:(NSString*)defaultContent inView:(UITableView*)tableView{
  static NSString *CellIdentifier = @"EditableCell";
  
  //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"EditableCell" owner:self options:nil];
    cell = (EditableCell*)editableCell;
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  cell.inputField.placeholder = defaultContent;
  
  return cell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  int section = [indexPath section];
  //これなに？
  if (section == 0){
    switch([indexPath row]){
      case 0:
        //TODO: これらの解放は？
        titleCell = [self createEditableCell:@"タイトル" inView:tableView];
        return titleCell;
      case 1:
        positionCell = [self createEditableCell:@"場所" inView:tableView];
        return positionCell;
    }
  }
  
  else if(section == 1){
    static NSString *CellIdentifier = @"DoubleRowCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    DoubleRowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"DoubleRowCell" owner:self options:nil];
      cell = (DoubleRowCell*)doubleRowCell;
      //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setTime:self.startTime endTime:self.endTime];
    
    return cell;
  }
  else if(section == 2){
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

    cell.textLabel.text = @"出発時刻の追加";
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"detailTextLabel - %d", indexPath.row];
    
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
  if(indexPath.section == 1){
    
    if (!self.workTimeDecideController) {
      self.workTimeDecideController = [[[WorkTimeDecideViewController alloc] initWithNibName:@"WorkTimeDecideViewController" bundle:nil] autorelease];
    }
    
    [self.workTimeDecideController setAddScheduleController:self];
    [self.navigationController pushViewController:self.workTimeDecideController animated:YES];
  }
  
  //出発時刻決定シークエンスへ
  else if(indexPath.section == 2){
    //TODO: 到着時刻入力を促す
    if(!self.departureDecideViewController){
      self.departureDecideViewController = [[[DepartureDecideViewController alloc] initWithNibName:@"DepartureDecideViewController" bundle:nil] autorelease];
      
    }
    
    DepartureData* data = self.departureDecideViewController.departureData;
    if(!data.departurePosition){
      data.departurePosition = @"自宅";
    }
    if(!data.arrivalPosition){
      data.arrivalPosition = positionCell.inputField.text;
    }
    
    
    data.departureTime = [self.startTime copy];
    data.arrivalTime = [self.startTime copy];
    data.startTime = [self.startTime copy];
    
    [self.navigationController pushViewController:self.departureDecideViewController animated:YES];
    [self.departureDecideViewController updateDepartureData:data];


  }
}


//文字列の入力が終わった際にキーボードを引っ込める
- (IBAction)endInputText:(id)sender {
  //[sourceText resignFirstResponder];
  //[destinationText resignFirstResponder];
  NSLog(@"End Push Button");
  
}

@end
