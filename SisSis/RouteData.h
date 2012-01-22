//
//  RouteData.h
//  SisSis
//
//  Created by 直毅 江川 on 12/01/23.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteData : NSObject {
  NSString *eventIdentifier;
  NSDate *startDate;
  NSDate *endDate;
  NSString *startLocate;
  NSString *endLocate;
  NSString *detailDescript;
}

@property (retain, nonatomic) NSString *eventIdentifier;
@property (retain, nonatomic) NSDate *startDate;
@property (retain, nonatomic) NSDate *endDate;
@property (retain, nonatomic) NSString *startLocate;
@property (retain, nonatomic) NSString *endLocate;
@property (retain, nonatomic) NSString *detailDescript;
@end
