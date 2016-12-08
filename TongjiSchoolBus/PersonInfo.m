//
//  PersonInfo.m
//  TongjiSchoolBus
//
//  Created by Leppard on 16/11/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import "PersonInfo.h"

static NSString *const kPersonName = @"name";
static NSString *const kPersonID = @"studentID";

@interface PersonInfo ()<NSCoding>

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *studentID;

@end

@implementation PersonInfo

#pragma mark - life cycle
+ (instancetype)sharedInfo
{
    static PersonInfo *info = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[PersonInfo alloc] init];
        info.name = @"";
        info.studentID = @"";
    });
    return info;
}

#pragma mark - public methods
- (void)setName:(NSString *)name studentID:(NSString *)studentID
{
    self.name = name;
    self.studentID = studentID;
}

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:kPersonName];
        _studentID = [aDecoder decodeObjectForKey:kPersonID];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kPersonName];
    [aCoder encodeObject:self.studentID forKey:kPersonID];
}


@end
