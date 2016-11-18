//
//  PersonInfo.h
//  TongjiSchoolBus
//
//  Created by Leppard on 16/11/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonInfo : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *studentID;

- (instancetype)initWithName:(NSString *)name studentID:(NSString *)studentID;

@end
