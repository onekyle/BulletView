//
//  YCBulletView.m
//  BulletView
//
//  Created by Durand on 16/11/18.
//  Copyright © 2016年 Durand. All rights reserved.
//

#import "YCBulletView.h"

#define Padding 10

@interface YCBulletView ()
@property (nonatomic,strong) UILabel *bulletLabel;
@end

@implementation YCBulletView
/** 初始化弹幕*/
-(instancetype)initWithBulletString:(NSString *)string
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        
        UIFont *labelFont = [UIFont systemFontOfSize:14];
        NSDictionary *attr = @{NSFontAttributeName:labelFont};
        CGFloat stringWidth = [string sizeWithAttributes:attr].width;
        
        _bulletLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = labelFont;
            label.textColor = [UIColor whiteColor];
            label;
        });
        [self addSubview:_bulletLabel];
        
        CGFloat heifht = 30;
        self.bounds = CGRectMake(0, 0, stringWidth + 2 * Padding, heifht);
        _bulletLabel.text = string;
        _bulletLabel.frame = CGRectMake(Padding, 0, stringWidth, heifht);
        
    }
    
    return self;
}
/** 开始动画*/
-(void)startAnimation
{
    // 弹幕开始
    self.moveStatusBlock(YCBulletMoveStatusStart);
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat bulletWidth = CGRectGetWidth(self.bounds);
    // 弹幕越长 动画时间越长, 速度越慢.
    CGFloat duration = (bulletWidth / (screenW / 4))  * 3.0;
    CGFloat wholeWidth = screenW + bulletWidth;
    
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDelay = bulletWidth / speed;
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDelay];
    
    __block CGRect frame = self.frame;
    frame.origin.x = screenW;
    self.frame = frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x = -bulletWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (self.moveStatusBlock) {
            self.moveStatusBlock(YCBulletMoveStatusEnd);
        }
    }];
}
/** 结束动画*/
-(void)stopAnimation
{
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(enterScreen) object:nil];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

-(void)enterScreen
{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(YCBulletMoveStatusEnter);
    }
}

@end
