//
//  OrderApi.h
//  TongjiSchoolBus
//
//  Created by Leppard on 18/11/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderApi : NSObject

+ (void)getBusListWithParams:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id resposeObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)makeOrderWithParams:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id resposeObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
