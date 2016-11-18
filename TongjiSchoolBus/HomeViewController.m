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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editProfile)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(gotoNext)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

#pragma mark - event response

- (void)editProfile
{
    ProfileViewController *profileController = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileController animated:YES];
}

- (void)gotoNext
{
    [OrderApi makeOrderWithParams:@{@"":@""}];
}

@end
