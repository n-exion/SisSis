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
  main_queue = dispatch_get_main_queue();
  load_queue = dispatch_queue_create("SisSis.eventlist.load", NULL);
  dispatch_async(load_queue, ^{
    EventListViewController *elvc = [[EventListViewController alloc]
                                     initWithNibName:@"EventListViewController"
                                     bundle:[NSBundle mainBundle]];
    elvc.loadingKeyArray = YES;
    [elvc initKeyArray];
    [elvc.eventTableView reloadData];
    elvc.loadingKeyArray = NO;
    elvc_dialog = elvc;
  });
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  segControl.selectedSegmentIndex = 2;
  NSDate *myTimeZoneDay = [NSDate dateWithTimeInterval:60*60*9 sinceDate:[NSDate date]];
  [self.monthView selectDate:myTimeZoneDay];
  [self.tableView reloadData];
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
}


- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	[self generateEventDataForStartDate:startDate endDate:lastDate];
	return dataArray;
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
	NSArray *ar = [dataDictionary objectForKey:[self.monthView dateSelected]];
	if(ar == nil) return 0;
	return [ar count];
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	NSArray *ar = [dataDictionary objectForKey:[self.monthView dateSelected]];
  EKEvent *event = [ar objectAtIndex:indexPath.row];
	cell.textLabel.text = event.title;
	
  return cell;
	
}

// EventStoreからイベント情報を生成
- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
  EKCalendar *cal = [appDelegate.eventStore defaultCalendarForNewEvents];
  
  NSPredicate *p = [appDelegate.eventStore predicateForEventsWithStartDate:start endDate:end calendars:[NSArray arrayWithObject:cal]];
  NSArray *events = [appDelegate.eventStore eventsMatchingPredicate:p];
	
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

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  EKEventViewController *eventViewController = [[[EKEventViewController alloc] init] autorelease];
  eventViewController.delegate = self;
  NSMutableArray *array = [dataDictionary objectForKey:self.monthView.dateSelected];
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
  NSDate *date = [self.monthView dateSelected];
  [self.monthView reload];
  [self.monthView selectDate:date];
  [self.tableView reloadData];
  [appDelegate.navController popViewControllerAnimated:YES];
}

// イベントハンドラから来る関数ども
// ツールバーで"今日"ボタンが押された
- (IBAction) didPushedTodayButton:(id)sender{
  NSDate *myTimeZoneDay = [NSDate dateWithTimeInterval:60*60*9 sinceDate:[NSDate date]];
  switch (segControl.selectedSegmentIndex) {
      // リスト形式
      case 0:
      break;
      // １日形式
      case 1:
      break;
      // 月形式
      case 2:
      NSLog(@"MonthView pushed todayButton");
      [self.monthView selectDate:myTimeZoneDay];
      [self.tableView reloadData];
      break;
      default:
      break;
  }
}

- (void) reload
{
  NSDate *date = [self.monthView dateSelected];
  [self.monthView reload];
  [self.monthView selectDate:date];
  [self.tableView reloadData];
}

- (void) changeViewFromSegmentControl:(NSInteger)value {
  if (value == 0) {
 /*   EventListViewController *dialog = [[EventListViewController alloc]
                                        initWithNibName:@"EventListViewController"
                                        bundle:[NSBundle mainBundle]];*/
    EventListViewController *dialog = elvc_dialog;
    dialog.delegate = self;
    [self.view addSubview:dialog.view];
  } else if (value == 1) {
    DayEventViewController *dialog = [[DayEventViewController alloc]
                                      initWithNibName:@"DayEventViewController"
                                      bundle:[NSBundle mainBundle]];
    dialog.nowDate = [self.monthView dateSelected];
    dialog.delegate = self;
    [self.view addSubview:dialog.view];
  } 
  segControl.selectedSegmentIndex = 2;
}

// ツールバーでカレンダーの表示形式が変更された
- (IBAction) changedSegmentedControlValue:(id)sender{
  [self changeViewFromSegmentControl:segControl.selectedSegmentIndex];
}

- (void) changedSegmentControlValue:(NSInteger)value {
  [self changeViewFromSegmentControl:value];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
