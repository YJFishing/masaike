//
//  scratchCardView.m
//  masaikeDemo
//
//  Created by 包宇津 on 2017/11/8.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import "scratchCardView.h"
@interface scratchCardView()
//手指路径
@property (nonatomic, assign) CGMutablePathRef path;
//储存所有的point
@property (nonatomic, strong) NSMutableArray *allPaths;
//储存每次手指触摸结束的point
@property (nonatomic, strong) NSMutableArray *appendPaths;
@property (nonatomic, strong) UIImageView *surfaceImageView;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation scratchCardView
- (NSMutableArray *)allPaths {
    if (_allPaths == nil) {
        _allPaths = [NSMutableArray array];
    }
    return _allPaths;
}

- (NSMutableArray *)appendPaths {
    if (_appendPaths == nil) {
        _appendPaths = [NSMutableArray array];
    }
    return _appendPaths;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageLayer.contents = (__bridge id _Nullable)(image.CGImage);
}

- (void)setSurfaceImage:(UIImage *)surfaceImage {
    _surfaceImage = surfaceImage;
    self.surfaceImageView.image = surfaceImage;
}
- (void)setup {
    self.surfaceImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.surfaceImageView];
    self.imageLayer = [CALayer layer];
    self.imageLayer.frame = self.bounds;
    [self.layer addSublayer:self.imageLayer];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineWidth = 10.0f;
    self.shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    self.shapeLayer.fillColor = nil;
    [self.layer addSublayer:self.shapeLayer];
    self.imageLayer.mask = self.shapeLayer;
    
    self.path = CGPathCreateMutable();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //开始一条可变路径
    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    self.appendPaths = [NSMutableArray array];
    [self.appendPaths addObject:[NSValue valueWithCGPoint:point]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //路径追加
    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    [self.appendPaths addObject:[NSValue valueWithCGPoint:point]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.allPaths addObject:self.appendPaths];
}

- (void)clear {
    [self.allPaths removeAllObjects];
    self.path = CGPathCreateMutable();
    CGPathMoveToPoint(self.path, NULL, 0, 0);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
}
- (void)back{
    [self.allPaths removeLastObject];
    self.path = CGPathCreateMutable();
    if (self.allPaths.count > 0) {
        for (int i = 0; i < self.allPaths.count; i++) {
            NSArray *array = self.allPaths[i];
            for (int j = 0; j < array.count; j++) {
                CGPoint point = [array[j] CGPointValue];
                if (j==0) {
                    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
                    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
                    self.shapeLayer.path = path;
                    CGPathRelease(path);
                }else {
                    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
                    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
                    self.shapeLayer.path = path;
                    CGPathRelease(path);
                }
            }
        }
    }else {
        [self clear];
    }
}

- (void)dealloc {
    if (self.path) {
        CGPathRelease(self.path);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
