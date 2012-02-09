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
@synthesize delegate;
@synthesize loadingKeyArray;

static id keyArray;
static id dataDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      // Custom initialization
      appDelegate = (SisSisAppDelegate*)[[UIApplication sharedApplication] delegate];
      loadingKeyArray = NO;
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
  if (loadingKeyArray) {
    return 0;
  }
  [self initKeyArray];
  return MAX([keyArray count], 1);
}

// EventStoreからイベント情報を生成
- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
  EKCalendar *cal = [appDelegate.eventStore defaultCalendarForNewEvents];
  
  NSPredicate *p = [appDelegate.eventStore predicateForEventsWithStartDate:start endDate:end calendars:[NSArray arrayWithObject:cal]];
  NSArray *events = [appDelegate.eventStore eventsMatchingPredicate:p];
	
	dataDictionary = [[NSMutableDictionary alloc] init];
	NSDate *d = start;
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy MM dd"];
	while (YES) {
    for (EKEvent *e in events) {
      NSString *nowDateStr = [dateFormatter stringFromDate:d];
      if ([d isSameDay:e.startDate]) {
        NSMutableArray *array = [dataDictionary objectForKey:d];
        if (!array) {
          array = [NSMutableArray array];
        }
        [array addObject:e];
        [dataDictionary setObject:array forKey:nowDateStr];
      }
    }
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end] == NSOrderedDescending) break;
	}
  [dateFormatter release];
}

- (void) initKeyArray
{
  if (keyArray) {
    return;
  }
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy MM dd"];
	NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];
  NSDateComponents *dateComp = [[NSDateComponents alloc] init];
  [dateComp setMonth:-1];
	NSDate *start = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:[NSDate date] options:0];
  [dateComp setMonth:2];
  NSDate *end = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:[NSDate date] options:0];
  [dateComp release];
  
  [self generateEventDataForStartDate:start endDate:end];
  
  NSArray *tempKeyArray = [(NSMutableDictionary *)dataDictionary allKeys];
  if (![dataDictionary objectForKey:nowDateStr]){
    NSMutableArray *tempArray = [tempKeyArray mutableCopy];
    [tempArray addObject:nowDateStr];
    keyArray = [[NSArray alloc] initWithArray:[tempArray sortedArrayUsingSelector:@selector(compare:)]];
    [tempArray release];
  } else {
    keyArray = [[NSArray alloc] initWithArray:[tempKeyArray sortedArrayUsingSelector:@selector(compare:)]];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (loadingKeyArray) {
    return 0;
  }
  NSString *key = [keyArray objectAtIndex:section];
  NSMutableArray *array = [dataDictionary objectForKey:key];
  if (!array) {
    return 0;
  }
  int count = [array count];
  return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"EventListCell";
  EventListCell *cell = (EventListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    UIViewController *vc = [[[UIViewController alloc] initWithNibName:@"EventListCell" bundle:nil] autorelease];
    cell = (EventListCell *)vc.view;
  }
  NSString *key = [keyArray objectAtIndex:indexPath.section];
  NSMutableArray *eventArray = [dataDictionary objectForKey:key];
  EKEvent *event = [eventArray objectAtIndex:indexPath.row];
  [cell.eventLabel setText:event.title];
  if (event.allDay) {
    [cell.timeLabel setText:@"終日"];
  } else {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm"];
    NSString *timeText = [outputFormatter stringFromDate:event.startDate];
    [cell.timeLabel setText:timeText];
    [outputFormatter release];
  }
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *title = [keyArray objectAtIndex:section];
  return title;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  EKEventViewController *eventViewController = [[EKEventViewController alloc] init];
  eventViewController.delegate = self;
  NSString *key = [keyArray objectAtIndex:indexPath.section];
  NSMutableArray *eventArray = [dataDictionary objectForKey:key];
  EKEvent *event = [eventArray objectAtIndex:indexPath.row];
  eventViewController.event = event;
  eventViewController.allowsEditing = YES;
  [appDelegate.navController pushViewController:eventViewController animated:YES];
}

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action
{
  NSError *error = nil;
  switch (action) {
    case EKEventViewActionDone:
      [appDelegate.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
      [self.eventTableView reloadData];
      break;
    case EKEventViewActionDeleted:
      [appDelegate.eventStore removeEvent:controller.event span:EKSpanThisEvent error:&error];
      [self.eventTableView reloadData];
      break;
    case EKEventViewActionResponded:
      break;
    default:
      break;
  }
  [appDelegate.navController popViewControllerAnimated:YES];
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
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy MM dd"];
	NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
  [dateFormatter release];
  for (i = 0; i < [(NSArray *)keyArray count]; i++) {
    NSString *ds = [keyArray objectAtIndex:i];
    if ([ds isEqualToString:nowDateStr]) {
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
