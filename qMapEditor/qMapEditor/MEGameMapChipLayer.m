//
//  MEGameMapChipLayer.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/19.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGameMapChipLayer.h"
#import "MEGameParts.h"

@implementation MEGameMapChipLayer

- (id)initWithGameParts:(MEGameParts *)gameParts1 x:(int)aspectX y:(int)aspectY t:(int)aspectT {
    if (self = [super init]) {
        _gameParts = gameParts1;
        _aspectX = aspectX;
        _aspectY = aspectY;
        _aspectT = aspectT;
    }
    return self;
}

- (void)fillBackground {
    self.backgroundColor = [[NSColor greenColor] CGColor];
}

- (void)runAnimation {
    [self fillBackground];

    CALayer *animationLayer = [CALayer layer];
    animationLayer.frame = self.bounds;
    [self addSublayer:animationLayer];
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
    [animationLayer addAnimation:keyAnimation forKey:@"aho"];
}

- (void)drawEmptyCursor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[NSColor clearColor] CGColor]];
    [self _drawLine:shapeLayer];
}

- (void)drawCurrentCursor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[NSColor yellowColor] CGColor]];
    [self _drawLine:shapeLayer];
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
@end
