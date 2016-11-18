//
//  ViewController.m
//  BulletView
//
//  Created by Durand on 16/11/18.
//  Copyright © 2016年 Durand. All rights reserved.
//

#import "ViewController.h"
#import "YCBulletManage.h"
#import "YCBulletView.h"

@interface ViewController ()
@property (nonatomic,strong) YCBulletManage *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[YCBulletManage alloc] init];
    __weak typeof(self)weakSelf = self;
    [self.manager setGenerateViewBlock:^(YCBulletView *view) {
        [weakSelf addBulletView:view];
    }];
    
    UIButton *startButton = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
        [btn setTitle:@"Start" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickStart) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:startButton];
    
    UIButton *stopButton = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 50, 50)];
        [btn setTitle:@"Stop" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickStop) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:stopButton];
}

-(void)didClickStart
{
    [self.manager start];
}

-(void)didClickStop
{
    [self.manager stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBulletView:(YCBulletView *)view
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(screenW, 300 + view.trajectory * 50, view.frame.size.width, view.frame.size.height);
    [self.view addSubview:view];
    
    [view startAnimation];
}

@end
