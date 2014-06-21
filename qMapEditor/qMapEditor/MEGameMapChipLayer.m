//
//  MEGameMapChipLayer.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/19.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGameMapChipLayer.h"
#import "MEGameParts.h"
#import "MEMatrix.h"

@implementation MEGameMapChipLayer

- (id)initWithGameParts:(MEGameParts *)gameParts1 x:(CGFloat)aspectX y:(CGFloat)aspectY t:(CGFloat)aspectT {
    if (self = [super init]) {
        _gameParts = gameParts1;
        _aspectX = aspectX;
        _aspectY = aspectY;
        _aspectT = aspectT;
        [self setBounds:CGRectMake(self.bounds.origin.x,self.bounds.origin.y , aspectX, aspectY+ aspectT)];
    }
    return self;
}

- (void)fillBackground {
    self.backgroundColor = [[NSColor greenColor] CGColor];
}

- (void)runAnimation {
//    [self fillBackground];

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetBlendMode(context, kCGBlendModeScreen);

    CALayer *animationLayer = [CALayer layer];


    animationLayer.frame = self.bounds;
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];

    NSMutableArray *array = [NSMutableArray array];
    CGImageRef maskRef;
    for (METile *tile in _gameParts.tiles) {
        NSImage *someImage = [tile image];
        CGImageSourceRef source;
        source = CGImageSourceCreateWithData((__bridge CFDataRef) [someImage TIFFRepresentation], NULL);
        maskRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        [array addObject:(__bridge id) (maskRef)];
    }

    NSLog(@"array:%@", array);
    keyAnimation.values = (NSArray *) array;
    keyAnimation.duration = 1.0f;
    keyAnimation.repeatCount = HUGE_VALF;
    [keyAnimation setCalculationMode:kCAAnimationDiscrete];

    [self addSublayer:animationLayer];
    [animationLayer addAnimation:keyAnimation forKey:@"aho"];
}

- (void)drawEmptyCursor {
    NSLog(@"emptyCursor");
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[NSColor clearColor] CGColor]];
    [self _drawLine:shapeLayer];
}

- (void)drawCurrentCursor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[NSColor yellowColor] CGColor]];
    [self _drawLine:shapeLayer];
}

- (void)drawGameParts {
    [self runAnimation];
}

- (void)_drawLine:(CAShapeLayer *)shapeLayer {
    [shapeLayer setStrokeColor:[[NSColor blueColor] CGColor]];
    [shapeLayer setLineCap:kCALineCapButt];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineWidth:1.0f];

    NSPoint from = NSMakePoint(
            NSMinX([self bounds]),
            NSMinY([self bounds]) + _aspectY / 2.0f
    );
    NSPoint to = NSMakePoint(
            NSMinX([self bounds]) + _aspectX / 2.0f,
            NSMinY([self bounds]) + _aspectY
    );
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, from.x, from.y);
    CGPathAddLineToPoint(path, NULL, to.x, to.y);

    from = to;
    to = NSMakePoint(
            NSMinX([self bounds]) + _aspectX,
            NSMinY([self bounds]) + _aspectY / 2.0f
    );
    CGPathAddLineToPoint(path, NULL, to.x, to.y);

    from = to;
    to = NSMakePoint(
            NSMinX([self bounds]) + _aspectX / 2.0f,
            NSMinY([self bounds])
    );
    CGPathAddLineToPoint(path, NULL, to.x, to.y);

    from = to;
    to = NSMakePoint(
            NSMinX([self bounds]),
            NSMinY([self bounds]) + _aspectY / 2.0f
    );
    CGPathAddLineToPoint(path, NULL, to.x, to.y);

    [shapeLayer setPath:path];
    [shapeLayer strokeStart];

    [self addSublayer:shapeLayer];
}

- (void)_drawLine:(NSPoint)from to:(NSPoint)to {
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line moveToPoint:from];
    [line lineToPoint:to];
    [line setLineWidth:1.0]; /// Make it easy to see
    [[NSColor blueColor] set];
    [line stroke];
}

//菱型のなかに収まっていればYES
+ (BOOL)hitCursorPointWithMatrix:(MEMatrix *)matrix
                         aspectX:(CGFloat)aspectX
                         aspectY:(CGFloat)aspectY
                             aid:(CGFloat)aid
                     mouseCursor:(CGPoint)cursorPoint
                    chipPosition:(CGPoint)chipPoint {
    CGFloat idealYUpper;
    CGFloat idealYDowner;
    if (cursorPoint.x < (chipPoint.x + aspectX / 2.0f)) {
        idealYUpper = aspectY / aspectX * cursorPoint.x +
                aspectY / 2.0f + aid - (matrix.x * aspectY);
        idealYDowner = aspectY / aspectX * -1.0f * cursorPoint.x +
                aspectY / 2.0f + aid + (matrix.y * aspectY);
    } else {
        idealYUpper = aspectY / aspectX * -1.0f * cursorPoint.x +
                aspectY * 3.0f / 2.0f + aid + (matrix.y * aspectY);
        idealYDowner = aspectY / aspectX * cursorPoint.x +
                -aspectY / 2.0f + aid - (matrix.x * aspectY);
    }
    if (cursorPoint.y < idealYUpper &&
            cursorPoint.y > idealYDowner
            ) {
        return YES;
    }
    return NO;
}

@end
