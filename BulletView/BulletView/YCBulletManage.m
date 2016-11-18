//
//  YCBulletManage.m
//  BulletView
//
//  Created by Durand on 16/11/18.
//  Copyright © 2016年 Durand. All rights reserved.
//

#import "YCBulletManage.h"
#import "YCBulletView.h"

@interface YCBulletManage ()
/** 弹幕的数据来源*/
@property (nonatomic,strong) NSMutableArray *dataSource;
/** 弹幕是数组变量*/
@property (nonatomic,strong) NSMutableArray *bulletStrings;
/** [弹幕View]*/
@property (nonatomic,strong) NSMutableArray *bulletViews;

@property (nonatomic,assign) BOOL animationIsStop;
@end

@implementation YCBulletManage

-(instancetype)init
{
    if (self = [super init]) {
        
        _animationIsStop = YES;
        
        _dataSource = ({
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:@[
                                                                    @"1111111~~~",
                                                                    @"@@@@!22222!~~",
                                                                    @"@#####333333~~~",
                                                                    @"1111111~~~",
                                                                    @"@@@@!22222!~~",
                                                                    @"@#####333333~~~",
                                                                    @"1111111~~~",
                                                                    @"@@@@!22222!~~",
                                                                    @"@#####333333~~~",
                                                                    @"1111111~~~",
                                                                    @"@@@@!22222!~~",
                                                                    @"@#####333333~~~",
                                                                    @"1111111~~~",
                                                                    @"@@@@!22222!~~",
                                                                    @"@#####333333~~~",
                                                                    ]];
            mArr;
        });
        
        _bulletStrings = ({
            NSMutableArray *mArr = [NSMutableArray array];
            mArr;
        });
        
        _bulletViews = ({
            NSMutableArray *mArr = [NSMutableArray array];
            mArr;
        });
        
    }
    return self;
}

/** 初始化弹幕,随机分配弹幕轨迹*/
-(void)initBulletString
{
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@1,@2,@3]];
    NSUInteger count = trajectorys.count;
    for (int i = 0; i < count; i ++) {
        if (_bulletStrings.count) {
            
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            NSString *bulletStr = _bulletStrings.firstObject;
            [_bulletStrings removeObjectAtIndex:0];
            
            [self createBulletView:bulletStr withTrajectory:trajectory];
        }
    }
}


-(void)createBulletView:(NSString *)bulletStr withTrajectory:(int)trajectory
{
    if (_animationIsStop) {
        return;
    }
    YCBulletView *view = [[YCBulletView alloc] initWithBulletString:bulletStr];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof(view)weakBullet = view;
    __weak typeof(self)weakSelf = self;
    view.moveStatusBlock = ^(YCBulletMoveStatus status){
        if (weakSelf.animationIsStop) {
            return ;
        }
        switch (status) {
            case YCBulletMoveStatusStart:
                // 弹幕开始进入屏幕, 判断是否还有其他内容, 如果有则在该弹幕轨迹中创建一个
                [weakSelf.bulletViews addObject:weakBullet];
                break;
            case YCBulletMoveStatusEnter:
                // 弹幕完全进入屏幕, 判断是否还有其他内容, 如果有就在该弹幕轨迹中创建一个弹幕
            {
                NSString *nextBulletStr = [weakSelf nextBulletString];
                if (nextBulletStr) {
                    [weakSelf createBulletView:nextBulletStr withTrajectory:trajectory];
                }
            }
                break;
            case YCBulletMoveStatusEnd:
                // 弹幕飞出屏幕后从 bulletViews中移除, 释放资源
                if ([weakSelf.bulletViews containsObject:weakBullet]) {
                    [weakBullet stopAnimation];
                    [weakSelf.bulletViews removeObject:weakBullet];
                }
                
                if (!weakSelf.bulletViews.count) {
                    // 说明屏幕上没有弹幕了, 开始循环滚动
                    weakSelf.animationIsStop = YES;
                    [weakSelf start];
                }
                break;
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

-(void)start
{
    if (!_animationIsStop) {
        return;
    }
    _animationIsStop = NO;
    [self.bulletStrings removeAllObjects];
    [self.bulletStrings addObjectsFromArray:self.dataSource];
    [self initBulletString];
}

-(void)stop
{
    if (_animationIsStop) {
        return;
    }
    _animationIsStop = YES;
    for (YCBulletView *view in self.bulletViews) {
        [view stopAnimation];
    }
    [self.bulletViews removeAllObjects];
    
}

-(NSString *)nextBulletString
{
    if (!self.bulletStrings.count) {
        return nil;
    }
    NSString *bulletStr = self.bulletStrings.firstObject;
    [self.bulletStrings removeObjectAtIndex:0];
    return bulletStr;
}
@end
