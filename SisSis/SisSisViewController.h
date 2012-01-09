//
//  SisSisViewController.h
//  SisSis
//
//  Created by Naoki Egawa on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapkuLibrary.h"

@interface SisSisViewController : TKCalendarMonthTableViewController {
  // カレンダービュー追加
  UIToolbar *toolBar;
  NSMutableArray *dataArray; 
	NSMutableDictionary *dataDictionary;
}

@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain,nonatomic) NSMutableArray *dataArray;
@property (retain,nonatomic) NSMutableDictionary *dataDictionary;

- (void) generateEventDataForStartDate:(NSDate*)start endDate:(NSDate*)end;
@end
