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
#import "DetailMapViewController.h"

#import "ScheduleData.h"


@implementation AddScheduleViewController

@synthesize editableCell;
@synthesize doubleRowCell;
@synthesize workTimeDecideController;
@synthesize departureDecideViewController;

@synthesize schedule;
@synthesize delegate;


- (id)initWithDate:(NSDate*) now
{
  self = [super initWithNibName:@"AddScheduleViewController" bundle:nil];
  if (self) {
    self.title = @"予定の追加";
    
    //登録するスケジュールデータの作成(初期値をここで与える)
    schedule = [[ScheduleData alloc] init];
    schedule.departurePosition = @"現在地点";
    schedule.departureTime = nil;
    
    //NSDate* now = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    //１時間足すよう
    NSDateComponents* diff = [[[NSDateComponents alloc] init] autorelease];
    diff.hour = 1;
    
    NSDateComponents *dateComps = [calendar components:NSMinuteCalendarUnit
                                              fromDate:now];
    
    diff.minute = -dateComps.minute;
    
    //予定開始時間
    schedule.startTime = [calendar dateByAddingComponents:diff toDate:now options:0];
    
    diff.hour = 2;
    schedule.endTime = [calendar dateByAddingComponents:diff toDate:now options:0];
    
    schedule.position = @"";
    schedule.arrivalPosition = nil;
    schedule.arrivalTime = nil;
    
    dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"MM-dd hh:mm"];
    [dateFormat setDateFormat:@"hh:mm"];
  }
  

  return self;
}

  


- (void) updateStartTime:(NSDate*)start{
  schedule.startTime = start;
  
  
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* diff = [[[NSDateComponents alloc] init] autorelease];
  diff.minute = -5;
  //予定開始時間
  schedule.arrivalTime = [calendar dateByAddingComponents:diff toDate:start options:0];

  DoubleRowCell* doubleCell =  (DoubleRowCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
  doubleCell.startTimeField.text = [dateFormat stringFromDate:start];
  [doubleCell setNeedsLayout];
}

- (void) updateEndTime:(NSDate*)end{

  schedule.endTime = end;

  
  DoubleRowCell* doubleCell =  (DoubleRowCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
  doubleCell.endTimeField.text = [dateFormat stringFromDate:end];
  [doubleCell setNeedsLayout];
}

- (NSString*) convertDateToString:(NSDate *)date{
  return [dateFormat stringFromDate:date];
}


- (void)dealloc
{
  [editableCell release];
  [workTimeDecideController release];
  [departureDecideViewController release];
  [dateFormat release];
  [schedule release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)pushPreviousButton{
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)completeButton{
  [delegate addedSchedule:self.schedule];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  UIBarButtonItem* returnButton = [[[UIBarButtonItem alloc] 
                                    initWithTitle:@"キャンセル" 
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(pushPreviousButton)] autorelease];
  
  UIBarButtonItem* completeButton = [[[UIBarButtonItem alloc] 
                                      initWithTitle:@"完了" 
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(completeButton)] autorelease];
  
  
  self.navigationItem.leftBarButtonItem = returnButton;
  self.navigationItem.rightBarButtonItem = completeButton;
  //self.navigationItem.rightBarButtonItem
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

//場所を変更したときのみ呼ばれるようになってる
-(void) textFieldDidEndEditing:(UITextField *)textField{
  if(textField.tag == 0){
    schedule.title = textField.text;
  }
  else if(textField.tag == 1){
    schedule.position = textField.text;
    schedule.arrivalPosition = textField.text;
  }

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
        titleCell.inputField.delegate = self;
        titleCell.inputField.tag = 0;
        return titleCell;
      case 1:
        positionCell = [self createEditableCell:@"場所" inView:tableView];
        positionCell.inputField.text = self->schedule.position;
        positionCell.inputField.delegate = self;
        positionCell.inputField.tag = 1;
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
      cell.addController = self;
      //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setTime:schedule.startTime endTime:schedule.endTime];
    
    return cell;
  }
  else if(section == 2){
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.textLabel.text = @"出発時刻の追加";
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"detailTextLabel - %d", indexPath.row];
    
    return cell;
  }
  
  
  return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //このタイミングでフォーム内容をデータscheduleに反映
  //時間系は面倒だからsetTime系でやってる
  //positionCell.inputField.text = self->schedule.position;
  schedule.title = ((EditableCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputField.text;
  schedule.position = ((EditableCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).inputField.text;
  
  //((EditableCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputField.
  
  //到着地点の処理. 本当はここじゃなくて場所の処理がおこった際にこの処理を行うべき
  if (schedule.arrivalPosition == nil){
    if (![schedule.position isEqualToString:@""]){
      schedule.arrivalPosition = schedule.position;
    }
  }

  if(indexPath.section == 1){
    if (!self.workTimeDecideController) {
      self.workTimeDecideController = [[[WorkTimeDecideViewController alloc] initWithNibName:@"WorkTImeDecideViewController" bundle:nil] autorelease];
      [self.workTimeDecideController setAddScheduleController:self];
    }
    
    //初回のセットなら
    if (schedule.arrivalTime == nil){
      schedule.arrivalTime = schedule.startTime;
    }

    [self.navigationController pushViewController:self.workTimeDecideController animated:YES];
  }
  
  //出発時刻決定シークエンスへ
  else if(indexPath.section == 2){
    //TODO: 到着時刻入力を促す
    //目的地を入れないと進めない
    if([positionCell.inputField.text isEqualToString:@""]){
      schedule.arrivalPosition = positionCell.inputField.text;
      UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                                       message:@"目的地を入力してください"
                                                      delegate:self 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles: nil] autorelease];
      [alert show];
      return;
    }
    
    [self textFieldDidEndEditing:positionCell.inputField];
    
    if(!self.departureDecideViewController){
      self.departureDecideViewController = [[[DepartureDecideViewController alloc] initWithNibName:@"DepartureDecideViewController" bundle:nil] autorelease];
      
      [self.departureDecideViewController setAddScheduleViewController:self];
      
    }
    

    [self.departureDecideViewController syncTableWithScheduleData];
    
    //[self.departureDecideViewController syncTableWithScheduleData];
    [self.navigationController pushViewController:self.departureDecideViewController animated:YES];
    
  }
}


//文字列の入力が終わった際にキーボードを引っ込める
- (IBAction)endInputText:(id)sender {
  //[sourceText resignFirstResponder];
  //[destinationText resignFirstResponder];
  NSLog(@"End Push Button");
  
}

@end
