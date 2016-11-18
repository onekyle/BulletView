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
    
    UIButton *stopButton = ({
        stopButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 100, 50, 50)];
        [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [stopButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [stopButton addTarget:self action:@selector(didClickStop) forControlEvents:UIControlEventTouchUpInside];
        stopButton;
    });
    [self.view addSubview:stopButton];
}

-(void)didClickStop
{
    [self.manager stop];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.manager start];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBulletView:(YCBulletView *)view
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(screenW, 300 + view.trajectory * 40, view.frame.size.width, view.frame.size.height);
    [self.view addSubview:view];
    
    [view startAnimation];
}

@end
