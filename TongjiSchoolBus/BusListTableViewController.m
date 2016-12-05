//
//  BusListTableViewController.m
//  TongjiSchoolBus
//
//  Created by Leppard on 01/12/2016.
//  Copyright © 2016 Leppard. All rights reserved.
//

#import "BusListTableViewController.h"
#import "BusListTableViewCell.h"

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
    
}

@end
