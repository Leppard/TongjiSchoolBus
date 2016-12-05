//
//  BusListTableViewCell.m
//  TongjiSchoolBus
//
//  Created by Leppard on 01/12/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import "BusListTableViewCell.h"
#import <Masonry.h>

@interface BusListTableViewCell ()

@property (nonatomic, strong) UILabel *carIdLabel;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation BusListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViewsWithConstraints];
    }
    return self;
}

- (void)configureWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary) {
        self.carIdLabel.text = [NSString stringWithFormat:@"班次: %@", [dictionary objectForKey:@"carId"]];
        self.lineLabel.text  = [dictionary objectForKey:@"line"];
        self.timeLabel.text  = [dictionary objectForKey:@"time"];
    }
}

- (void)setUpViewsWithConstraints
{
    [self addSubview:self.carIdLabel];
    [self addSubview:self.lineLabel];
    [self addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height).multipliedBy(0.5);
        make.width.equalTo(@80);
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.5);
    }];
    [self.carIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.timeLabel);
        make.width.equalTo(@60);
        make.left.equalTo(self.timeLabel.mas_right).offset(30);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.timeLabel);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.timeLabel.mas_left);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(1.5);
    }];
}

#pragma mark - getters & setters
- (UILabel *)carIdLabel
{
    if (!_carIdLabel) {
        _carIdLabel = [[UILabel alloc] init];
        _carIdLabel.font = [UIFont systemFontOfSize:13];
    }
    return _carIdLabel;
}

- (UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.font = [UIFont systemFontOfSize:13];
    }
    return _lineLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _timeLabel;
}

@end
