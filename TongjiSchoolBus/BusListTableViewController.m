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

@property (nonatomic, strong) UIAlertController *successAlert;
@property (nonatomic, strong) UIAlertController *failureAlert;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, assign) NSInteger carIdCount;

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
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.indicator];
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

    self.carIdCount = 0;
    [self makeOrderWithParams:params withCarId:carId];
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

- (void)makeOrderWithParams:(NSDictionary *)params withCarId:(NSString *)carId
{
    self.carIdCount ++;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic setValue:carId forKey:@"carid"];
    
    __weak typeof(self) weakSelf = self;
    [OrderApi makeOrderWithParams:dic
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if([responseObject isKindOfClass:[NSData class]]) {
                                  NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  if (![str containsString:@"null"]) {
                                      // 订票成功
                                      if (weakSelf.indicator.hidden == NO) {
                                          [weakSelf.indicator stopAnimating];
                                          weakSelf.indicator.hidden = YES;
                                          [weakSelf.failureAlert dismissViewControllerAnimated:YES completion:nil];
                                      }
                                      UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                      }];
                                      [weakSelf.successAlert addAction:action];
                                      [weakSelf presentViewController:weakSelf.successAlert animated:YES completion:nil];
                                  } else {
                                      // 订票失败
                                      if (self.carIdCount == 1) {
                                          // carIdCount == 1代表第一次递归，只有这次会弹提示框
                                          UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                                          UIAlertAction *fakeOrder = [UIAlertAction actionWithTitle:@"生成" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                              [weakSelf.indicator startAnimating];
                                              weakSelf.indicator.hidden = NO;
                                              
                                              [weakSelf makeOrderWithParams:params withCarId:[NSString stringWithFormat:@"%ld", self.carIdCount]];
                                          }];
                                          [weakSelf.failureAlert addAction:cancel];
                                          [weakSelf.failureAlert addAction:fakeOrder];
                                          [weakSelf presentViewController:weakSelf.failureAlert animated:YES completion:nil];
                                      } else {
                                          if (self.carIdCount < 33) {
                                              [weakSelf makeOrderWithParams:params withCarId:[NSString stringWithFormat:@"%ld", self.carIdCount]];
                                          }
                                      }
                                  }
                              }
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              NSLog(@"order fail");
                          }];
}

#pragma mark - getters & setters
- (UIAlertController *)successAlert
{
    if (!_successAlert) {
        _successAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"订票成功" preferredStyle:UIAlertControllerStyleAlert];
    }
    return _successAlert;
}

- (UIAlertController *)failureAlert
{
    if (!_failureAlert) {
        _failureAlert = [UIAlertController alertControllerWithTitle:@"失败" message:@"票已订完，可以强行生成一张票（学生端可以查看，司机端查看不到但可以通过扫码）" preferredStyle:UIAlertControllerStyleAlert];
    }
    return _failureAlert;
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indicator.userInteractionEnabled = YES;
        _indicator.hidden = YES;
    }
    return _indicator;
}

@end
