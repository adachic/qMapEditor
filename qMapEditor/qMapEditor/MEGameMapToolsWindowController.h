//
//  MEGameMapToolsWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MEGameMapToolsWindowController : NSWindowController

@property IBOutlet NSTextField *tfAspectX;
@property IBOutlet NSTextField *tfAspectY;
@property IBOutlet NSTextField *tfAspectT;
@property IBOutlet NSTextField *tfParhaps;

@property IBOutlet NSButton *buttonAspectFix;
@property IBOutlet NSView *sampleTileView;

@property CGFloat aspectX;
@property CGFloat aspectY;
@property CGFloat aspectT;


- (IBAction)clickedAspectFix:(id)sender;
- (void)showParhapsSize:(CGFloat)x y:(CGFloat)y t:(CGFloat)t;

@end
