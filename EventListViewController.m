//
//  EventListViewController.m
//  SisSis
//
//  Created by 直毅 江川 on 12/01/23.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "EventListViewController.h"

@implementation EventListViewController

@synthesize eventTableView;
@synthesize segControl;
@synthesize toolBar;
@synthesize todayButton;
@synthesize keyArray;
@synthesize nowDate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      // Custom initialization
      appDelegate = (SisSisAppDelegate*)[[UIApplication sharedApplication] delegate];
      [self initKeyArray];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  [self initKeyArray];
  return MAX([keyArray count], 1);
}

- (void) initKeyArray
{
  if (keyArray) {
    [keyArray release];
  }
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
	nowDate = [dateFormatter dateFromString:nowDateStr];
	[dateFormatter release];
  NSArray *tempKeyArray = appDelegate.dataDictionary.allKeys;
  if (![appDelegate.dataDictionary objectForKey:nowDate]){
    NSMutableArray *tempArray = [tempKeyArray mutableCopy];
    [tempArray addObject:nowDate];
    keyArray = [[NSArray alloc] initWithArray:[tempArray sortedArrayUsingSelector:@selector(compare:)]];
  } else {
    keyArray = [[NSArray alloc] initWithArray:[tempKeyArray sortedArrayUsingSelector:@selector(compare:)]];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSDate *key = [keyArray objectAtIndex:section];
  if (![appDelegate.dataDictionary objectForKey:key]) {
    return 0;
  }
  NSMutableArray *array = [appDelegate.dataDictionary objectForKey:key];
  return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[EventListCell alloc] 
             initWithStyle:UITableViewCellStyleDefault 
             reuseIdentifier:CellIdentifier] 
             autorelease];
  }
  NSDate *key = [keyArray objectAtIndex:indexPath.section];
  NSMutableArray *eventArray = [appDelegate.dataDictionary objectForKey:key];
  EKEvent *event = [eventArray objectAtIndex:indexPath.row];
  cell.eventName.text = event.title;
  if (event.allDay) {
    cell.time.text = @"終日";
  } else {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm"];
    cell.time.text = [outputFormatter stringFromDate:event.startDate];
  }
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSDate *date = [keyArray objectAtIndex:section];
  NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
  [outputFormatter setDateFormat:@"yyyy MM dd"];
  NSString *str = [outputFormatter stringFromDate:date];
  [outputFormatter release];
  return str; //ビルド警告回避用
}

// ツールバーでカレンダーの表示形式が変更された
- (IBAction) changedSegmentedControlValue:(id)sender{
  switch (segControl.selectedSegmentIndex) {
    // １日形式
    case 1:
      break;
      // 月形式
    case 2:
      [self.view removeFromSuperview];
      break;
    default:
      break;
  }
}

@end
