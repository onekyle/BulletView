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
@end

@implementation YCBulletManage

-(instancetype)init
{
    if (self = [super init]) {
        
        _dataSource = ({
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:
                                    @[@"1111111~~~",
                                    @"@@@@!22222!~~",
                                    @"@#####333333~~~",]
                                    ];
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
    
    for (int i = 0; i < trajectorys.count; i ++) {
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
    YCBulletView *view = [[YCBulletView alloc] initWithBulletString:bulletStr];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof(view)weakBullet = view;
    __weak typeof(self)weakSelf = self;
    view.moveStatusBlock = ^{
        [weakBullet stopAnimation];
        [weakSelf.bulletViews removeObject:weakBullet];
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

-(void)start
{
    [self.bulletStrings removeAllObjects];
    [self.bulletStrings addObjectsFromArray:self.dataSource];
    [self initBulletString];
}

-(void)stop
{
    
}
@end
