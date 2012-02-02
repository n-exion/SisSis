//
//  ScheduleObject.h
//  SisSis
//
//  Created by じょん たいたー on 12/01/30.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <Foundation/Foundation.h>


//出発情報をまとめたクラス
@interface ScheduleData : NSObject{
  //出発場所
  NSString* departurePosition;
  NSDate* departureTime;
  
  //到着場所
  NSString* arrivalPosition;
  NSDate* arrivalTime;
  
  //予定の場所
  NSString* position;
  NSDate* startTime;
  NSDate* endTime;
  
  //タイトル
  NSString* title;
  
}

@property (strong,nonatomic) NSString* departurePosition;
@property (strong,nonatomic) NSDate* departureTime;
@property (strong,nonatomic) NSString* arrivalPosition;
@property (strong,nonatomic) NSDate* arrivalTime;
@property (strong,nonatomic) NSString* position;
@property (strong,nonatomic) NSDate* startTime;
@property (strong,nonatomic) NSDate* endTime;
@property (strong,nonatomic) NSString* title;


@end


