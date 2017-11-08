//
//  scratchCardView.h
//  masaikeDemo
//
//  Created by 包宇津 on 2017/11/8.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scratchCardView : UIView
//要刮的图片
@property (nonatomic, strong) UIImage *image;
//图层图片
@property (nonatomic, strong) UIImage *surfaceImage;

- (void)clear;
- (void)back;
@end
