//
//  HomeViewController.m
//  TongjiSchoolBus
//
//  Created by Leppard on 09/11/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "BusListTableViewController.h"
#import "OrderApi.h"
#import <Masonry/Masonry.h>

@interface HomeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *areaArray;

@property (nonatomic, strong) UIPickerView *startArea;
@property (nonatomic, strong) UIPickerView *endArea;

@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) NSArray *monthNames;
@property (nonatomic, strong) NSDateComponents *currentDate;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _areaArray = @[@"四平", @"嘉定", @"沪西", @"曹杨八村", @"三门路同济北苑"];
    _currentDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    _monthNames = [df monthSymbols];
    
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
    NSDateComponents *selectComps = [[NSDateComponents alloc] init];
    selectComps.year = self.currentDate.year+[self.datePicker selectedRowInComponent:0];
    selectComps.month = [self.datePicker selectedRowInComponent:1]+1;
    selectComps.day = [self.datePicker selectedRowInComponent:2]+1;
    NSDate *selectDate = [[NSCalendar currentCalendar] dateFromComponents:selectComps];
    
    NSDictionary *params = @{
                             @"startArea": [self.areaArray objectAtIndex:[self.startArea selectedRowInComponent:0]],
                             @"endArea": [self.areaArray objectAtIndex:[self.endArea selectedRowInComponent:0]],
                             @"startDate":[formatter stringFromDate:selectDate]
                             };
    
    __weak typeof(self) weakSelf = self;
    [OrderApi getBusListWithParams:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               BusListTableViewController *controller = [[BusListTableViewController alloc] initWithDataList:(NSArray *)responseObject];
                               [weakSelf.navigationController pushViewController:controller animated:YES];
    }
                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                               NSLog(@"Network failed");
                           }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView != self.datePicker) {
        return 1;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView != self.datePicker) {
        return 5;
    } else {
        switch (component) {
            case 0:
                return 2;
                break;
            case 1:
                return 12;
                break;
            case 2: {
                NSDateComponents *selectMothComps = [[NSDateComponents alloc] init];
                selectMothComps.year = self.currentDate.year+[pickerView selectedRowInComponent:0];
                selectMothComps.month = [pickerView selectedRowInComponent:1]+1;
                selectMothComps.day = 1;
                
                NSDateComponents *nextMothComps = [[NSDateComponents alloc] init];
                nextMothComps.year = selectMothComps.year;
                nextMothComps.month = selectMothComps.month+1;
                nextMothComps.day = 1;
                
                NSDate *thisMonthDate = [[NSCalendar currentCalendar] dateFromComponents:selectMothComps];
                NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateFromComponents:nextMothComps];
                
                NSDateComponents *differnce = [[NSCalendar currentCalendar]  components:NSCalendarUnitDay
                                                                               fromDate:thisMonthDate
                                                                                 toDate:nextMonthDate
                                                                                options:0];
                return differnce.day;
                break;
            }
            default:
                return 0;
                break;
        }
    }
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        if (pickerView != self.datePicker) {
            label.text = [self.areaArray objectAtIndex:row];
        } else {
            switch (component) {
                case 0:
                    label.text = [NSString stringWithFormat:@"%ld", self.currentDate.year+row];
                    break;
                case 1:
                    label.text = [self.monthNames objectAtIndex:row];
                    break;
                case 2:
                    label.text = [NSString stringWithFormat:@"%ld", row+1];
                    break;
                default:
                    break;
            }
        }
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.datePicker && component != 2) {
        [pickerView reloadComponent:2];
    }
    return;
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

- (UIPickerView *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] init];
        _datePicker.dataSource = self;
        _datePicker.delegate = self;
    }
    return _datePicker;
}

@end
