//
//  MEGameMapWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MEMatrix;

@interface MEGameMapWindowController : NSWindowController <NSWindowDelegate>


typedef void (^_onSetToToolWindow)(MEMatrix *_maxM, CGFloat _x, CGFloat _y, CGFloat _t);

@property (strong) _onSetToToolWindow onSetToToolWindow;

@property MEMatrix *maxM;
@property CGFloat aspectX;
@property CGFloat aspectY;
@property CGFloat aspectT;

@property BOOL shouldShowUpper;
@property BOOL shouldShowGriph;
@property BOOL shouldShowLines;

- (id)initWithWindowNibName:(NSString *)windowNibName
                    fileURL:(NSURL *)url
                       maxM:(MEMatrix *)maxSize
                    aspectX:(CGFloat)x
                    aspectY:(CGFloat)y
                    aspectT:(CGFloat)t;
- (void)fixedValuesFromToolBar:(MEMatrix *)maxM x:(CGFloat)x y:(CGFloat)y t:(CGFloat)t;

@end
