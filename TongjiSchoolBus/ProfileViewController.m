//
//  ProfileViewController.m
//  TongjiSchoolBus
//
//  Created by Leppard on 16/11/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import "ProfileViewController.h"
#import "PersonInfo.h"
#import <Masonry.h>

@interface ProfileViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *idField;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishEditing)];
    [self.view addGestureRecognizer:tap];
    
    [self preCheckAndFillInfo];
    [self setUpViewsWithConstraints];
}

#pragma mark - event response
- (void)save
{
    // 这里做一次去除String空格的处理
    self.nameField.text = [self.nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.idField.text = [self.idField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.nameField.text.length == 0 || self.idField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    PersonInfo *info = [[PersonInfo alloc] initWithName:self.nameField.text studentID:self.idField.text];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"kPersonalInfo"];
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishEditing
{
    [self.view endEditing:YES];
}

#pragma mark - private methods
- (void)setUpViewsWithConstraints
{
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.idLabel];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.idField];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.4);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.view.mas_centerX).offset(20);
        make.bottom.equalTo(self.idField.mas_top).offset(-20);
    }];
    [self.idField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.nameField.mas_width);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.nameField.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@30);
        make.right.equalTo(self.nameField.mas_left).offset(-5);
        make.centerY.equalTo(self.nameField.mas_centerY);
    }];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@30);
        make.right.equalTo(self.idField.mas_left).offset(-5);
        make.centerY.equalTo(self.idField.mas_centerY);
    }];
}

- (void)preCheckAndFillInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"kPersonalInfo"];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (object && [object isMemberOfClass:[PersonInfo class]]) {
        PersonInfo *info = (PersonInfo *)object;
        self.nameField.text = info.name;
        self.idField.text = info.studentID;
    }
}

#pragma mark - getters & setters
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.text = @"姓名";
    }
    return _nameLabel;
}

- (UILabel *)idLabel
{
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] init];
        _idLabel.font = [UIFont systemFontOfSize:13];
        _idLabel.text = @"学号";
    }
    return _idLabel;
}

- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc] init];
        _nameField.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        _nameField.font = [UIFont systemFontOfSize:13];
        _nameField.layer.borderWidth = 1.0;
        _nameField.layer.cornerRadius = 5.0;
        _nameField.placeholder = @"请输入姓名";
        _nameField.textAlignment = NSTextAlignmentCenter;
    }
    return _nameField;
}

- (UITextField *)idField
{
    if (!_idField) {
        _idField = [[UITextField alloc] init];
        _idField.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        _idField.font = [UIFont systemFontOfSize:13];
        _idField.layer.borderWidth = 1.0;
        _idField.layer.cornerRadius = 5.0;
        _idField.placeholder = @"请输入学号";
        _idField.textAlignment = NSTextAlignmentCenter;
    }
    return _idField;
}

@end
