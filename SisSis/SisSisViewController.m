//
//  SisSisViewController.m
//  SisSis
//
//  Created by Naoki Egawa on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import "SisSisViewController.h"
#import <EventKit/EventKit.h>

@implementation SisSisViewController

@synthesize toolBar;
@synthesize dataArray;
@synthesize dataDictionary;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.monthView selectDate:[NSDate month]];

}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
  //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
  //[dateFormatter setDateFormat:@"dd.MM.yy"]; 
  //NSDate *d = [dateFormatter dateFromString:@"02.05.11"]; 
  //[dateFormatter release];
  //[self.monthView selectDate:d];
}

- (void)loadView
{
  [super loadView];
  [self.monthView reload];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
  if (self.monthView != nil) [self.monthView release];
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
	cell.textLabel.text = [ar objectAtIndex:indexPath.row];
	
  return cell;
	
}

- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
  EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
  EKCalendar *cal = [eventStore defaultCalendarForNewEvents];
  
  NSPredicate *p = [eventStore predicateForEventsWithStartDate:start endDate:end calendars:[NSArray arrayWithObject:cal]];
  NSArray *events = [eventStore eventsMatchingPredicate:p];
	
	self.dataArray = [NSMutableArray array];
	self.dataDictionary = [NSMutableDictionary dictionary];
	
	NSDate *d = start;
	while(YES){
		
    BOOL exist = NO;
    for (EKEvent *e in events) {
      if ([d isSameDay:e.startDate]) {
        
        NSMutableArray *array = [self.dataDictionary objectForKey:d];
        if (!array) {
          array = [NSMutableArray array];
        }
        [self.dataDictionary setObject:array forKey:d];
        [array addObject:e.title];
        exist = YES;
      }
    }
    [self.dataArray addObject:[NSNumber numberWithBool:exist]];
    
    //		int r = arc4random();
    //		if(r % 3==1){
    //			[self.dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",@"Item two",nil] forKey:d];
    //			[self.dataArray addObject:[NSNumber numberWithBool:YES]];
    //			
    //		}else if(r%4==1){
    //			[self.dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",nil] forKey:d];
    //			[self.dataArray addObject:[NSNumber numberWithBool:YES]];
    //			
    //		}else
    //			[self.dataArray addObject:[NSNumber numberWithBool:NO]];
		
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end]==NSOrderedDescending) break;
	}
	
}

@end
