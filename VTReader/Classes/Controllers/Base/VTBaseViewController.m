//
//  VTBaseViewController.m
//  VTEpub
//
//  Created by JinJie Song on 2018/3/31.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTBaseViewController.h"

#import "VTBaseView.h"

@interface VTBaseViewController ()

@end

@implementation VTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    _contentView = [[UIView alloc] initWithFrame:frame];
    _containerView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    
    VTBaseView *view = [[VTBaseView alloc] initWithFrame:frame];
    self.view = view;
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.containerView];
    
    [self.view bringSubviewToFront:self.containerView];
    [self.view bringSubviewToFront:self.contentView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
