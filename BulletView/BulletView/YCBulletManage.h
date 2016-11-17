//
//  YCBulletManage.h
//  BulletView
//
//  Created by Durand on 16/11/18.
//  Copyright © 2016年 Durand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCBulletView;
@interface YCBulletManage : NSObject

@property (nonatomic,copy) void(^generateViewBlock)(YCBulletView *view);

-(void)start;

-(void)stop;
@end
