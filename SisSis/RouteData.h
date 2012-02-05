//
//  RouteData.h
//  SisSis
//
//  Created by 直毅 江川 on 12/02/05.
//  Copyright (c) 2012年 東京工業大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICGDirections.h"

//経路情報をまとめたクラス
@interface RouteData : NSObject {
  //イベント識別子
  NSString* identifier;
  //出発場所
  NSString* departurePosition;
  NSDate* departureTime;
  
  //到着場所
  NSString* arrivalPosition;
  NSDate* arrivalTime;
  
  //ルート検索の種類
  NSInteger travelMode;
    
}

@property (strong,nonatomic) NSString* identifier;
@property (strong,nonatomic) NSString* departurePosition;
@property (strong,nonatomic) NSDate* departureTime;
@property (strong,nonatomic) NSString* arrivalPosition;
@property (strong,nonatomic) NSDate* arrivalTime;
@property (nonatomic) NSInteger travelMode;

@end
