//
//  METileView.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "METileView.h"
#import <QuartzCore/QuartzCore.h>

@implementation METileView

- (id)initWithAspectX:(CGFloat)x aspectY:(CGFloat)y aspectT:(CGFloat)tall frame:(CGRect)frame {
//    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, x, y + tall)];
    self = [super initWithFrame:CGRectMake(0, 0, x, y + tall)];
    if (self) {
        // Initialization code here.
        _aspectX = x;
        _aspectY = y;
        _aspectT = tall;
        [self setWantsLayer:YES];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void)drawFillColor {
}


- (void)drawLine {
    self.layer.backgroundColor = [[NSColor greenColor] CGColor];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[NSColor clearColor] CGColor]];
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

    [self.layer addSublayer:shapeLayer];
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
