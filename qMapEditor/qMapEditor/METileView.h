//
//  METileView.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface METileView : NSView
- (id)initWithAspectX:(CGFloat)x aspectY:(CGFloat)y aspectT:(CGFloat)tall frame:(CGRect)frame;
- (void)drawLine;

@property CGFloat aspectX;
@property CGFloat aspectY;
@property CGFloat aspectT;

@end
