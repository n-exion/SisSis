//
//  TestTapkuAppDelegate.h
//  TestTapku
//
//  Created by じょん たいたー on 11/12/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestTapkuViewController;

@interface TestTapkuAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TestTapkuViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TestTapkuViewController *viewController;

@end

