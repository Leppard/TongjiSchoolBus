//
//  BusListTableViewController.m
//  TongjiSchoolBus
//
//  Created by Leppard on 01/12/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import "BusListTableViewController.h"
#import "BusListTableViewCell.h"
#import "PersonInfo.h"
#import "OrderApi.h"

@interface BusListTableViewController ()

@property (nonatomic, strong) NSArray *listArray;

@end

@implementation BusListTableViewController

- (instancetype)initWithDataList:(NSArray *)listArray
{
    self = [super init];
    if (self && listArray) {
        _listArray = listArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BusListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BusListTableViewCell class])];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BusListTableViewCell class]) forIndexPath:indexPath];
    [cell configureWithDictionary:[self.listArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    
    if (![self checkIfStudentInfoComplete]) {
        return;
    }
    
    NSDictionary *params = [self makeUpParamsForOrderAtIndexPath:indexPath];
    
    NSString *carId = [[self. listArray objectAtIndex:indexPath.row] objectForKey:@"carId"];
    // try real carId to make a order
    BOOL ifSuccess = [self tryMakeOrderWithParams:params withCarId:carId];
//    if (!ifSuccess) {
//        [self tryMakeOrderWithParams:params withCarId:[NSString stringWithFormat:@"99"]];
//    }
}

#pragma mark - private methods
- (NSDictionary *)makeUpParamsForOrderAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self.listArray objectAtIndex:indexPath.row];
    
    NSString *yesterdayStr = [self yesterdayFromDateString:[dictionary objectForKey:@"startDate"]];
    NSString *reserveStr = [NSString stringWithFormat:@"%@ 07:01", yesterdayStr];
    
    NSDictionary *params = @{
                             @"startArea": [dictionary objectForKey:@"startArea"],
                             @"endArea": [dictionary objectForKey:@"endArea"],
                             @"startTime": [dictionary objectForKey:@"time"],
                             @"startDate": [dictionary objectForKey:@"startDate"],
                             @"line": [dictionary objectForKey:@"line"],
                             @"sno": [PersonInfo sharedInfo].studentID,
                             @"sname": [PersonInfo sharedInfo].name,
                             @"reservetime": reserveStr
                             };
    return params;
}

- (BOOL)checkIfStudentInfoComplete
{
    if ([PersonInfo sharedInfo].studentID.length == 0 || [PersonInfo sharedInfo].name.length == 0) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"个人信息不全，点击首页Edit" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}

- (NSString *)yesterdayFromDateString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string];
    NSDate *yesterday = [date dateByAddingTimeInterval: -86400.0];
    NSString *yesterdayStr = [dateFormatter stringFromDate:yesterday];
    return yesterdayStr;
}

- (BOOL)tryMakeOrderWithParams:(NSDictionary *)params withCarId:(NSString *)carId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic setValue:carId forKey:@"carid"];
    
    __block BOOL ifSuccess = NO;
#warning - 把ifSuccess 变成全局的
    [OrderApi makeOrderWithParams:dic
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if([responseObject isKindOfClass:[NSData class]]) {
                                  NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  if (![str containsString:@"null"]) {
                                      ifSuccess = YES;
                                  }
                              }
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              NSLog(@"order fail");
                          }];
    return ifSuccess;
}

@end
