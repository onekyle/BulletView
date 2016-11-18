//
//  YCBulletView.h
//  BulletView
//
//  Created by Durand on 16/11/18.
//  Copyright © 2016年 Durand. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YCBulletMoveStatus) {
    YCBulletMoveStatusStart,
    YCBulletMoveStatusEnter,
    YCBulletMoveStatusEnd,
};

@interface YCBulletView : UIView
/** 弹道*/
@property (nonatomic,assign) int trajectory;
/** 弹幕状态回调*/
@property (nonatomic,copy) void(^moveStatusBlock)(YCBulletMoveStatus status);

/** 初始化弹幕*/
-(instancetype)initWithBulletString:(NSString *)string;
/** 开始动画*/
-(void)startAnimation;
/** 结束动画*/
-(void)stopAnimation;
@end
