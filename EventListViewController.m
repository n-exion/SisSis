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
@synthesize delegate;


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
  if (dataArray) {
    [dataArray release];
  }
  if (dataDictionary) {
    [dataDictionary release];
  }
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

// EventStoreからイベント情報を生成
- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
  EKCalendar *cal = [appDelegate.eventStore defaultCalendarForNewEvents];
  
  NSPredicate *p = [appDelegate.eventStore predicateForEventsWithStartDate:start endDate:end calendars:[NSArray arrayWithObject:cal]];
  NSArray *events = [appDelegate.eventStore eventsMatchingPredicate:p];
	
  if (dataArray) {
    [dataArray release];
  }
  if (dataDictionary) {
    [dataDictionary release];
  }
	dataArray = [[NSMutableArray alloc] init];
	dataDictionary = [[NSMutableDictionary alloc] init];
	
	NSDate *d = start;
	while(YES){
    BOOL exist = NO;
    for (EKEvent *e in events) {
      if ([d isSameDay:e.startDate]) {
        NSMutableArray *array = [dataDictionary objectForKey:d];
        if (!array) {
          array = [NSMutableArray array];
        }
        [dataDictionary setObject:array forKey:d];
        [array addObject:e];
        exist = YES;
      }
    }
    [dataArray addObject:[NSNumber numberWithBool:exist]];
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end]==NSOrderedDescending) break;
	}
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
  NSDateComponents *dateComp = [[NSDateComponents alloc] init];
  [dateComp setMonth:-1];
	NSDate *start = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:[NSDate date] options:0];
  [dateComp setMonth:3];
  NSDate *end = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:[NSDate date] options:0];
  [dateComp release];
  [self generateEventDataForStartDate:start endDate:end];
  NSArray *tempKeyArray = dataDictionary.allKeys;
  if (![dataDictionary objectForKey:nowDate]){
    NSMutableArray *tempArray = [tempKeyArray mutableCopy];
    [tempArray addObject:nowDate];
    keyArray = [[NSArray alloc] initWithArray:[tempArray sortedArrayUsingSelector:@selector(compare:)]];
    [tempArray release];
  } else {
    keyArray = [[NSArray alloc] initWithArray:[tempKeyArray sortedArrayUsingSelector:@selector(compare:)]];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSDate *key = [keyArray objectAtIndex:section];
  if (![dataDictionary objectForKey:key]) {
    return 0;
  }
  NSMutableArray *array = [dataDictionary objectForKey:key];
  return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"EventListCell";
  EventListCell *cell = (EventListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    UIViewController *vc = [[UIViewController alloc] initWithNibName:@"EventListCell" bundle:nil];
    cell = (EventListCell *)vc.view;
  }
  NSDate *key = [keyArray objectAtIndex:indexPath.section];
  NSMutableArray *eventArray = [[dataDictionary objectForKey:key] autorelease];
  EKEvent *event = [eventArray objectAtIndex:indexPath.row];
  [cell.eventLabel setText:event.title];
  if (event.allDay) {
    [cell.timeLabel setText:@"終日"];
  } else {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm"];
    NSString *timeText = [outputFormatter stringFromDate:event.startDate];
    [cell.timeLabel setText:timeText];
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
  [delegate changedSegmentControlValue:segControl.selectedSegmentIndex];
  [self.view removeFromSuperview];
  segControl.selectedSegmentIndex = 0;
}

// ツールバーで"今日"ボタンが押された
- (IBAction) didPushedTodayButton:(id)sender{
  int i;
  for (i = 0; i < keyArray.count; i++) {
    NSDate *d = [keyArray objectAtIndex:i];
    if (d == nowDate) {
      break;
    }
  }
  NSIndexPath* indexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:i];
  switch (segControl.selectedSegmentIndex) {
      // リスト形式
    case 0:
      // NSIndexPath で指定したセルが表示されるように UITableView をスクロールします。
      [self.eventTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
      break;
      // １日形式
    case 1:
      break;
      // 月形式
    case 2:
      break;
    default:
      break;
  }
}

@end
