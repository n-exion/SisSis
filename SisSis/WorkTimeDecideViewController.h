//
//  ViewController.h
//  WorkTimeDecider
//
//  Created by じょん たいたー on 12/01/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddScheduleViewController;

@interface WorkTimeDecideViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    //現在, どちらの時刻を編集中か
    NSInteger selectedField;
    
    NSDateFormatter* dateFormat;
    AddScheduleViewController* addScheduleController;
}
@property (retain, nonatomic) IBOutlet UITableView *DataTable;
@property NSInteger selectedField;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;

-(void) setAddScheduleController: (AddScheduleViewController*) controller;

@end
