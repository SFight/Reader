//
//  ViewController.m
//  VTReaderTest
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "ViewController.h"

#import <VTReader/VTReader.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 100, 300, 50);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SEL
- (void)onClickButton:(UIButton *)button
{
    NSError *error;
    NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"三言二拍（插图版）" ofType:@"epub"];
    NSString *dstPath = [[NSString documentsPath] stringByAppendingPathComponent:@"三言二拍.epub"];
    [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:&error];
    NSURL *path = [NSURL fileURLWithPath:[[NSString documentsPath] stringByAppendingPathComponent:@"三言二拍.epub"]];
    
    [[VTReaderManager sharedInstance] openReaderWithPath:path type:VT_READER_TYPE_EPUB inViewController:self onDismiss:^BOOL(UIViewController *viewController) {
        
        return YES;
    }];
}


@end
