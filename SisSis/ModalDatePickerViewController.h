//
//  ModalDatePickerViewController.h
//  SisSis
//
//  Created by じょん たいたー on 12/02/04.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddScheduleViewController;
@class DepartureDecideViewController;

@interface ModalDatePickerViewController : UIViewController{
  AddScheduleViewController* addMainController;
  DepartureDecideViewController* departureController;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak,nonatomic) AddScheduleViewController* addMainController;
@property (weak,nonatomic) DepartureDecideViewController* departureController;

-(IBAction) pushDecideButton:(id)sender;

@end
