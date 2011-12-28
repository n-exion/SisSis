//
//  SisSisAppDelegate.h
//  SisSis
//
//  Created by 直毅 江川 on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SisSisViewController;

@interface SisSisAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SisSisViewController *viewController;

@end
