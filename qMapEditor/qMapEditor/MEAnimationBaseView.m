//
//  MEAnimationBaseView.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/11.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEAnimationBaseView.h"

@implementation MEAnimationBaseView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
    if(_editable){
        CGContextSetRGBFillColor(context, 0.227,0.551,0.237,0.8);
    }else{
        CGContextSetRGBFillColor(context, 0.027,0.051,0.037,0.8);
    }
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
}

- (void)switchMode{
    _editable = !_editable;
    [self setNeedsDisplay:YES];
}

@end
