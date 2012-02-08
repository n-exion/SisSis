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
@synthesize backImageView;
@synthesize nowDate;
@synthesize navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
  backImageView = [[UIImageView alloc] initWithImage:[img imageByScalingProportionallyToSize:CGSizeMake(320.0, 1250.0)]];
  scrollView.pagingEnabled = NO;  
  scrollView.contentSize = backImageView.frame.size;  
  scrollView.showsHorizontalScrollIndicator = NO;  
  scrollView.showsVerticalScrollIndicator = YES;  
  scrollView.scrollsToTop = YES;  
  scrollView.delegate = self;  
  [scrollView addSubview:backImageView];
  
  if (nowDate) {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy MM dd"];
    navTitle.title = [outputFormatter stringFromDate:nowDate];
    [outputFormatter release];
  }
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
