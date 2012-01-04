//
//  SisSisViewController.h
//  SisSis
//
//  Created by Naoki Egawa on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapkuLibrary.h"

@interface SisSisViewController : UIViewController {
  // カレンダービュー追加
  TKCalendarMonthView *monthView;
  UINavigationBar *navBar;
  UIToolbar *toolBar;
}

@property (retain, nonatomic) TKCalendarMonthView *monthView;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@end
