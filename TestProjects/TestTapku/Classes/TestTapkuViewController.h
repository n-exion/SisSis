//
//  TestTapkuViewController.h
//  TestTapku
//
//  Created by じょん たいたー on 11/12/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapkuLibrary.h"

@interface TestTapkuViewController : UIViewController {
	TKCalendarMonthView* monthView;
	
}

@property (retain,nonatomic) TKCalendarMonthView *monthView;

@end

