//
//  OrderApi.m
//  TongjiSchoolBus
//
//  Created by Leppard on 18/11/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import "OrderApi.h"
#import <AFNetworking/AFHttpSessionManager.h>

static NSString *const kBusListUrlString = @"http://202.120.164.35:8080/cws/ws/rest/seachdaytimeinfo";
static NSString *const kMakeOrderUrlString = @"http://202.120.164.35:8080/cws/ws/rest/saveticket";

@implementation OrderApi

+ (void)getBusListWithParams:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id resposeObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if (!params) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:kBusListUrlString parameters:params progress:nil
         success:success
         failure:failure];
}

+ (void)makeOrderWithParams:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id resposeObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if (!params) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:kMakeOrderUrlString parameters:params progress:nil
         success:success
         failure:failure];
}

@end
