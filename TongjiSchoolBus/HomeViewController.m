//
//  HomeViewController.m
//  TongjiSchoolBus
//
//  Created by Leppard on 09/11/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import <Masonry/Masonry.h>

//remove later
#import "OrderApi.h"

@interface HomeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *areaArray;

@property (nonatomic, strong) UIPickerView *startArea;
@property (nonatomic, strong) UIPickerView *endArea;

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _areaArray = @[@"四平", @"嘉定", @"沪西", @"曹杨八村", @"三门路同济北苑"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editProfile)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(gotoNext)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self setUpViewsWithConstraints];
}

#pragma mark - event response
- (void)editProfile
{
    ProfileViewController *profileController = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileController animated:YES];
}

- (void)gotoNext
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDictionary *params = @{
                             @"startArea": [self.areaArray objectAtIndex:[self.startArea selectedRowInComponent:0]],
                             @"endArea": [self.areaArray objectAtIndex:[self.endArea selectedRowInComponent:0]],
                             @"startDate":[formatter stringFromDate:self.datePicker.date]
                             };
    
    [OrderApi getBusListWithParams:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSLog(@"%@", responseObject);
    }
                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                               NSLog(@"network failed");
                           }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = [self.areaArray objectAtIndex:row];
    return label;
}

#pragma mark - private methods
- (void)setUpViewsWithConstraints
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"->";
    
    [self.view addSubview:self.startArea];
    [self.view addSubview:self.endArea];
    [self.view addSubview:label];
    [self.view addSubview:self.datePicker];
    
    [self.startArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5).offset(-20);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.3);
        make.right.equalTo(self.view.mas_centerX).offset(-20);
        make.bottom.equalTo(self.view.mas_centerY).offset(-20);
    }];
    [self.endArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.startArea.mas_width);
        make.height.equalTo(self.startArea.mas_height);
        make.left.equalTo(self.view.mas_centerX).offset(20);
        make.bottom.equalTo(self.startArea.mas_bottom);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.startArea.mas_centerY);
    }];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.startArea.mas_height);
        make.width.equalTo(self.startArea.mas_width).multipliedBy(2);
        make.top.equalTo(self.view.mas_centerY).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - getters & setters
- (UIPickerView *)startArea
{
    if (!_startArea) {
        _startArea = [[UIPickerView alloc] init];
        _startArea.dataSource = self;
        _startArea.delegate = self;
    }
    return _startArea;
}

- (UIPickerView *)endArea
{
    if (!_endArea) {
        _endArea = [[UIPickerView alloc] init];
        _endArea.dataSource = self;
        _endArea.delegate = self;
    }
    return _endArea;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.date = [NSDate date];
    }
    return _datePicker;
}

@end
