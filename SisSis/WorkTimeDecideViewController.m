//
//  ViewController.m
//  WorkTimeDecider
//
//  Created by じょん たいたー on 12/01/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WorkTimeDecideViewController.h"
#import "AddScheduleViewController.h"
#import "ScheduleData.h"

@implementation WorkTimeDecideViewController
@synthesize DataTable;
@synthesize selectedField;
@synthesize datePicker;

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
  
  //自分から情報を供給する
  self.DataTable.delegate = self;
  self.DataTable.dataSource = self;
  
  //datePicker関係
  selectedField = 0;
  
}

-(void) setAddScheduleController: (AddScheduleViewController*) controller{
  self->addScheduleController = controller; 
}


- (void)viewDidUnload
{
  [self setDataTable:nil];
  [self setDatePicker:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  UITableViewCell* cell = [self.DataTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  cell.detailTextLabel.text = [addScheduleController convertDateToString:addScheduleController.schedule.startTime];
  
  cell = [self.DataTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
  cell.detailTextLabel.text = [addScheduleController convertDateToString:addScheduleController.schedule.endTime];
  
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 2;
}

//表示された後にデータを共有
- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSDate* startDate,*endDate;
  startDate = self->addScheduleController.schedule.startTime;
  endDate = self->addScheduleController.schedule.endTime;
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
  }
  
  dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"MM-dd hh:mm"];
  NSString* date_converted;
  
  // Configure the cell...
  switch (indexPath.row){
    case 0:
      cell.textLabel.text = @"開始時刻";
      date_converted = [dateFormat stringFromDate:startDate];
      
      cell.detailTextLabel.textAlignment = UITextAlignmentRight;
      cell.detailTextLabel.text = date_converted;
      break;
    case 1:
      cell.textLabel.text = @"終了時刻";
      date_converted = [dateFormat stringFromDate:endDate];
      
      cell.detailTextLabel.textAlignment = UITextAlignmentRight;
      cell.detailTextLabel.text = date_converted;
      break;
      
  }
  
  return cell;
}

- (IBAction)setAlerm{
  UITableViewCell* targetCell;
  
  switch(selectedField){
    case 0:
      [addScheduleController updateStartTime:datePicker.date];
      break;
    case 1:
      [addScheduleController updateEndTime:datePicker.date];
      break;
  }
  //全体更新
  //[self->addScheduleController.tableView reloadData];
  targetCell = [DataTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedField inSection:0]];
  targetCell.detailTextLabel.text = [dateFormat stringFromDate:datePicker.date];
  
  //特定のcellを更新
  [targetCell setNeedsLayout];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row){
    case 0:
      selectedField = 0;
      break;
    case 1:
      selectedField = 1;
      break;
  }
  
  NSDate* target;
  switch (selectedField) {
    case 0:
      target = addScheduleController.schedule.startTime;
      break;
    case 1:
      target = addScheduleController.schedule.endTime;
      break;
  }
  
  [datePicker setDate:target];
}

- (void)dealloc {
  [DataTable release];
  [datePicker release];
  [dateFormat release];
  [super dealloc];
}
@end
