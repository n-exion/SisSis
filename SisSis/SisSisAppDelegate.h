//
//  SisSisAppDelegate.h
//  SisSis
//
//  Created by Naoki Egawa on 11/12/28.
//  Copyright 2011年 東京工業大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SisSisViewController;

@interface SisSisAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  //SisSisViewController *viewController;
  UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet SisSisViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end
