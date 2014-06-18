//
//  MEGameMapToolsWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MEMatrix;

@interface MEGameMapToolsWindowController : NSWindowController<NSWindowDelegate>

typedef void (^_onSetToMapWindow)(MEMatrix *_maxM, CGFloat _x, CGFloat _y, CGFloat _t);

@property (strong) _onSetToMapWindow onSetToMapWindow;

@property IBOutlet NSTextField *tfAspectX;
@property IBOutlet NSTextField *tfAspectY;
@property IBOutlet NSTextField *tfAspectT;
@property IBOutlet NSTextField *tfParhaps;

@property IBOutlet NSButton *buttonAspectFix;
@property IBOutlet NSView *sampleTileView;

@property CGFloat aspectX;
@property CGFloat aspectY;
@property CGFloat aspectT;
@property MEMatrix *maxM;


- (IBAction)clickedAspectFix:(id)sender;
- (void)showParhapsSize:(CGFloat)x y:(CGFloat)y t:(CGFloat)t;
- (void)changedMapWindow:(MEMatrix *)maxM x:(CGFloat)x y:(CGFloat)y t:(CGFloat)t;

@end
