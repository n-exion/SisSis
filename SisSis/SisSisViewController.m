//
//  SisSisViewController.m
//  SisSis
//
//  Created by Naoki Egawa on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import "SisSisViewController.h"

@implementation SisSisViewController

@synthesize segControl;
@synthesize toolBar;
@synthesize todayButton;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView{
  appDelegate = (SisSisAppDelegate*)[[UIApplication sharedApplication] delegate];
  [super loadView];
}

- (void)viewWillAppear:(BOOL)animated {
  // 画面が表示される直前にする処理
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  //[self.monthView selectDate:[NSDate month]];
  segControl.selectedSegmentIndex = 2;
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
  [super dealloc];
  if (self.monthView != nil) [self.monthView release];
}


- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	[self generateEventDataForStartDate:startDate endDate:lastDate];
	return appDelegate.dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
	
	NSLog(@"Date Selected: %@",myTimeZoneDay);
	
	[self.tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
	[super calendarMonthView:mv monthDidChange:d animated:animated];
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	NSArray *ar = [appDelegate.dataDictionary objectForKey:[self.monthView dateSelected]];
	if(ar == nil) return 0;
	return [ar count];
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  
	
	NSArray *ar = [appDelegate.dataDictionary objectForKey:[self.monthView dateSelected]];
  EKEvent *event = [ar objectAtIndex:indexPath.row];
	cell.textLabel.text = event.title;
	
  return cell;
	
}

// EventStoreからイベント情報を生成
- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
  EKCalendar *cal = [appDelegate.eventStore defaultCalendarForNewEvents];
  
  NSPredicate *p = [appDelegate.eventStore predicateForEventsWithStartDate:start endDate:end calendars:[NSArray arrayWithObject:cal]];
  NSArray *events = [appDelegate.eventStore eventsMatchingPredicate:p];
	
	appDelegate.dataArray = [NSMutableArray array];
	appDelegate.dataDictionary = [NSMutableDictionary dictionary];
	
	NSDate *d = start;
	while(YES){
    BOOL exist = NO;
    for (EKEvent *e in events) {
      if ([d isSameDay:e.startDate]) {
        NSMutableArray *array = [appDelegate.dataDictionary objectForKey:d];
        if (!array) {
          array = [NSMutableArray array];
        }
        [appDelegate.dataDictionary setObject:array forKey:d];
        [array addObject:e];
        exist = YES;
      }
    }
    [appDelegate.dataArray addObject:[NSNumber numberWithBool:exist]];
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end]==NSOrderedDescending) break;
	}
}

- (void) addEventData {
  EKEvent *event = [EKEvent eventWithEventStore:appDelegate.eventStore];
  event.title = @"This is title.";
  event.location = @"Tokyo, Japan.";
  event.startDate = [NSDate dateWithTimeIntervalSinceNow:0.0f];
  event.endDate = [NSDate dateWithTimeIntervalSinceNow:3*60];
  event.notes = @"This is notes.";
  //[self.eventStore saveEvent:event span:EKSpanThisEvent error:&error];
  EKEventEditViewController *eventEditViewController = [[[EKEventEditViewController alloc] init] autorelease];
  eventEditViewController.editViewDelegate = self;
  eventEditViewController.event = event;
  eventEditViewController.eventStore = appDelegate.eventStore;
  [self presentModalViewController:eventEditViewController animated:YES];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action
{
	
	NSError *error = nil;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			break;
			
		case EKEventEditViewActionSaved:
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
			
		case EKEventEditViewActionDeleted:
			[controller.eventStore removeEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
			
		default:
			break;
	}
  [self.monthView reload];
	[controller dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  EKEventViewController *eventViewController = [[[EKEventViewController alloc] init] autorelease];
  eventViewController.delegate = self;
  NSMutableArray *array = [appDelegate.dataDictionary objectForKey:self.monthView.dateSelected];
  eventViewController.event = [array objectAtIndex:indexPath.row];
  eventViewController.allowsEditing = YES;
//  [self presentModalViewController:eventViewController animated:YES];
  [appDelegate.navController pushViewController:eventViewController animated:YES];
}

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action
{
  NSError *error = nil;
  switch (action) {
    case EKEventViewActionDone:
      [appDelegate.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
      break;
    case EKEventViewActionDeleted:
      [appDelegate.eventStore removeEvent:controller.event span:EKSpanThisEvent error:&error];
      break;
    case EKEventViewActionResponded:
      break;
    default:
      break;
  }
  [self.monthView reload];
  [controller dismissModalViewControllerAnimated:YES];
}

- (void) changeViewToEventList
{
  EventListViewController *dialog = [[EventListViewController alloc]
                                     initWithNibName:@"EventListViewController"
                                     bundle:[NSBundle mainBundle]];
  [self.view addSubview:dialog.view];
  //[self presentModalViewController:dialog animated:NO];
}

// イベントハンドラから来る関数ども
// ツールバーで"今日"ボタンが押された
- (IBAction) didPushedTodayButton:(id)sender{
  NSDate *now = [NSDate date];
  switch (segControl.selectedSegmentIndex) {
      // リスト形式
      case 0:
      break;
      // １日形式
      case 1:
      break;
      // 月形式
      case 2:
      // とりあえず今日ボタンが押された時に予定を足してみる。
      NSLog(@"MonthView pushed todayButton");
      [self.monthView selectDate:now];
      [self.monthView reload];
      [self.tableView reloadData];
      break;
      default:
      break;
  }
}

// ツールバーでカレンダーの表示形式が変更された
- (IBAction) changedSegmentedControlValue:(id)sender{
  switch (segControl.selectedSegmentIndex) {
      // リスト形式
    case 0:
      [self changeViewToEventList];
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
  segControl.selectedSegmentIndex = 2;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
