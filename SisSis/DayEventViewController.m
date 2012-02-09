//
//  DayEventViewController.m
//  SisSis
//
//  Created by 直毅 江川 on 12/02/02.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import "DayEventViewController.h"
@implementation DayEventViewController

@synthesize scrollView;
@synthesize segControl;
@synthesize toolBar;
@synthesize todayButton;
@synthesize delegate;
@synthesize nowDate;
@synthesize navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      // Custom initialization
      appDelegate = (SisSisAppDelegate*)[[UIApplication sharedApplication] delegate];
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
  segControl.selectedSegmentIndex = 1;
  UIImage *img = [UIImage imageNamed:@"back.png"];
  UIImageView *backImageView = [[UIImageView alloc] initWithImage:[img imageByScalingProportionallyToSize:CGSizeMake(320.0, 1250.0)]];
  scrollView.pagingEnabled = NO;  
  scrollView.contentSize = backImageView.frame.size;  
  scrollView.showsHorizontalScrollIndicator = NO;  
  scrollView.showsVerticalScrollIndicator = YES;  
  scrollView.scrollsToTop = YES;  
  scrollView.delegate = self;
  scrollView.delaysContentTouches = NO;
  [scrollView addSubview:backImageView];
  [backImageView release];

  if (!nowDate) {
    nowDate = [NSDate date];
  }
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
  nowDate = [dateFormatter dateFromString:nowDateStr];
  [dateFormatter release];
  NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
  [outputFormatter setDateFormat:@"yyyy MM dd"];
  navTitle.title = [outputFormatter stringFromDate:nowDate];
  [outputFormatter release];
  [self generateEventDataForStartDate:nowDate];
  EventRectView *eventRectView = [[[EventRectView alloc] initWithEvents:dataArray] autorelease];
  eventRectView.delegate = self;
  eventRectView.opaque = NO;
  eventRectView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
  [scrollView addSubview:eventRectView];
  UITapGestureRecognizer* tapGesture = 
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];  
  [scrollView addGestureRecognizer:tapGesture];  
  [tapGesture release];
}

- (void) handleTapGesture:(UITapGestureRecognizer*)sender {  
  NSLog(@"tap");  
  CGPoint tapPoint = [sender locationInView:self.scrollView];
  EventRectView* erv;
  for (int i = 0; i < [scrollView.subviews count]; i++) {
    id subView = [scrollView.subviews objectAtIndex:i];
    if ([subView isKindOfClass:[EventRectView class]]) {
      erv = subView;
    }
  }
  for (int i = 0; i < [erv.eventRects count]; i++) {
    CGRect rect = [[erv.eventRects objectAtIndex:i] CGRectValue];
    if (CGRectContainsPoint(rect, tapPoint)) {
      NSLog(@"taped%d", i);
      [self showEKEventViewController:[erv.eventArray objectAtIndex:i]];
    }
  }
}

- (void) showEKEventViewController:(EKEvent*) event
{
  EKEventViewController *eventViewController = [[[EKEventViewController alloc] init] autorelease];
  eventViewController.event = event;
  eventViewController.allowsEditing = NO;
  [appDelegate.navController pushViewController:eventViewController animated:YES];
}

- (void)finishedRectDraw:(CGRect)rect
{
  [scrollView zoomToRect:rect animated:YES];
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

// EventStoreから一日のイベント情報を取得
- (void) generateEventDataForStartDate:(NSDate*)start {
  EKCalendar *cal = [appDelegate.eventStore defaultCalendarForNewEvents];
  NSDateComponents *dc  = [[NSDateComponents alloc] init];
  [dc setDay:1];
  NSDate *end = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:start options:0];
  [dc release];
  NSPredicate *p = [appDelegate.eventStore predicateForEventsWithStartDate:start endDate:end calendars:[NSArray arrayWithObject:cal]];
  NSArray *events = [appDelegate.eventStore eventsMatchingPredicate:p];
	
  if (dataArray) {
    [dataArray release];
  }
	dataArray = [[NSMutableArray alloc] init];
	
	NSDate *d = start;
  for (EKEvent *e in events) {
    if ([d isSameDay:e.startDate]) {
      [dataArray addObject:e];
    }
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (!scrollView.dragging) {
    [self.nextResponder touchesBegan:touches withEvent:event];
  }
  [super touchesBegan:touches withEvent:event];
}

// ツールバーで"今日"ボタンが押された
- (IBAction) didPushedTodayButton:(id)sender{
  switch (segControl.selectedSegmentIndex) {
      // リスト形式
    case 0:
      // NSIndexPath で指定したセルが表示されるように UITableView をスクロールします。
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

// ツールバーでカレンダーの表示形式が変更された
- (IBAction) changedSegmentedControlValue:(id)sender{
  [delegate changedSegmentControlValue:segControl.selectedSegmentIndex];
  [self.view removeFromSuperview];
  segControl.selectedSegmentIndex = 1;
}
@end
