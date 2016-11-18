//
//  OrderApi.m
//  TongjiSchoolBus
//
//  Created by Leppard on 18/11/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import "OrderApi.h"
#import <AFNetworking/AFHttpSessionManager.h>

@implementation OrderApi

+ (void)makeOrderWithParams:(NSDictionary *)params
{
    if (!params) {
        return;
    }
    
    NSString *urlString = @"http://httpbin.org/get";
    params = @{
               @"name": @"Li",
               @"gender": @"male"
               };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:params progress:nil
         success:^(NSURLSessionDataTask *task, id resposeObject) {
             NSLog(@"%@", resposeObject);
    }
         failure:nil];
}

@end
