//
//  EventListViewController.m
//  SisSis
//
//  Created by 直毅 江川 on 12/01/23.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "EventListViewController.h"

@implementation EventListViewController

@synthesize tableView;
@synthesize segControl;
@synthesize toolBar;
@synthesize todayButton;
@synthesize sectionDict;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      // Custom initialization
      appDelegate = (SisSisAppDelegate*)[[UIApplication sharedApplication] delegate];
      [self initSectionArray];
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
  NSInteger sections = [appDelegate.dataDictionary count];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
	NSDate *nowDate = [dateFormatter dateFromString:nowDateStr];
	[dateFormatter release];
  NSMutableArray *array = [appDelegate.dataDictionary objectForKey:nowDate];
  if (!array) {
    sections++;
  }
  return MAX(sections, 1);
}

- (void) initSectionArray
{
  sectionDict = [NSMutableDictionary dictionary];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
	NSDate *nowDate = [dateFormatter dateFromString:nowDateStr];
	[dateFormatter release];
  NSEnumerator *objEnum = [appDelegate.dataDictionary objectEnumerator];
  NSEnumerator *keyEnum = [appDelegate.dataDictionary keyEnumerator];
  NSMutableArray *array;
  NSDate *d;
  NSInteger index;
  index = 0;
  BOOL todayFlg = NO;
  while (array = [objEnum nextObject]) {
    d = [keyEnum nextObject];
    if (!todayFlg) {
      if ([nowDate isEqualToDate:d]) {
        todayFlg = YES;
      } else if (nowDate != [nowDate earlierDate:d]) {
        todayFlg = YES;
        [sectionDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                nowDate, @"date", [NSNumber numberWithInt:0], @"count",nil]
                        forKey:[NSNumber numberWithInt:index]];
        index++;
      }
    }
    [sectionDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            d, @"date", [NSNumber numberWithInt:[array count]], @"count",nil]
                    forKey:[NSNumber numberWithInt:index]];
    index++;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSDictionary *dict = [sectionDict objectForKey:[NSNumber numberWithInt:section]];
  NSNumber *number = [dict objectForKey:@"count"];
  return [number integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSDictionary *dict = [sectionDict objectForKey:[NSNumber numberWithInt:section]];
  NSDate *date = [dict objectForKey:@"date"];
  NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
  [outputFormatter setDateFormat:@"yyyy MM dd"];
  NSString *str = [outputFormatter stringFromDate:date];
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
