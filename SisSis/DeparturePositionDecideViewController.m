//
//  StartPositionDecideViewController.m
//  TestStartDecideView
//
//  Created by じょん たいたー on 12/01/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeparturePositionDecideViewController.h"
#import "DepartureDecideViewController.h"
#import "AddScheduleViewController.h"
#import "ScheduleData.h"

#import "ButtonEditableCell.h"

@implementation DeparturePositionDecideViewController
@synthesize buttonEditableCell;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
  }
  return self;
}

-(void)setDeparturePositionDecideViewController:(DepartureDecideViewController *)controller{
  departureDecideViewController = controller;
}

-(void)setAddScheduleViewController:(AddScheduleViewController *)controller{
  addController = controller;
}

//データの追加とともに設定に保存する
-(void)addDeparturePosition:(NSString*)position{
  [positionList addObject:position];
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:positionList forKey:@"positionList"];

}

-(void)deleteDeparturePosition:(NSInteger)index{
  [positionList removeObjectAtIndex:index];
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

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSArray* savedList = [defaults arrayForKey:@"positionList"];
  
  if (savedList) {
    positionList = [[NSMutableArray alloc] initWithArray:savedList];
  }
  else{
    positionList = [[NSMutableArray alloc] init];
    [positionList addObject:@"現在地点"];
  }
  
  int numPositionList = [positionList count];
  BOOL findStart = NO;
  
  for(int i = 0; i < numPositionList;i++){
    if([[positionList objectAtIndex:i] isEqualToString:@"現在地点"] )
         findStart = YES;
  }
  if(!findStart){
    [positionList insertObject:@"現在地点" atIndex:0];
  }

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
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  switch(section){
    case 0:
      return [positionList count];
    case 1:
      return 1;
  }
  
  return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  if(indexPath.section == 0){
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      CGRect frame = CGRectMake(0, 0, 300,44);
      
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      
      cell.frame = frame;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
      UIButton* deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      deleteButton.frame = CGRectMake(240.0, 5.0, 50.0, 35.0);
      [deleteButton setTitle:@"削除" forState:UIControlStateNormal];
      [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
      
      deleteButton.backgroundColor = [UIColor clearColor];
      deleteButton.tag = 1;

      [deleteButton addTarget:self action:@selector(pushDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
      
      [cell addSubview:deleteButton];

    }
    
    cell.textLabel.text = [positionList objectAtIndex:indexPath.row];
    return cell;
  }
  else if(indexPath.section == 1){
    static NSString *CellIdentifier = @"ButtonEditableCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ButtonEditableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"ButtonEditableCell" owner:self options:nil];
      cell = (ButtonEditableCell*)buttonEditableCell;

    }

    cell.inputField.placeholder = @"新しい出発地点";
    return cell;
  }
  
  // Configure the cell...
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
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  switch(section){
    case 0:
      return @"出発地点";
    case 1:
      return @"出発地点の追加";
    default:
      return @"適当";
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   [detailViewController release];
   */
  int section = indexPath.section;
  
  //位置を指定したら前の画面に戻りつつ、場所入力
  if(section == 0){
    UITableViewCell* targetCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString* positionName = targetCell.textLabel.text;
    
    addController.schedule.departurePosition = positionName;
    [departureDecideViewController syncTableWithScheduleData];
    [self.navigationController popViewControllerAnimated:YES];
        
  }
}

- (IBAction)pushAddButton:(id)sender {
  ButtonEditableCell* cell = (ButtonEditableCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
  NSString* new_position = cell.inputField.text;

  //未入力ならなにもしない
  if ([new_position isEqualToString:@""])
    return;
  
  [cell.inputField resignFirstResponder];
  
  NSIndexPath* path = [NSIndexPath indexPathForRow:[positionList count] inSection:0];
  [self.tableView beginUpdates];

  [self addDeparturePosition:new_position];
  //[positionList addObject:new_position];
  
  [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationRight];
  
  [self.tableView endUpdates];

}

- (void)pushDeleteButton:(id)sender{
  UIButton* button = (UIButton*)sender;
  UITableViewCell *cell = (UITableViewCell*)[button superview];
  NSIndexPath* path = [self.tableView indexPathForCell:cell];
  
  [self deleteDeparturePosition:path.row];
  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationRight];
  
  
}

- (IBAction)endEditing:(id)sender {
  [sender resignFirstResponder];
}


- (void)dealloc {
  [buttonEditableCell release];
  [positionList release];
  [super dealloc];
}
@end
