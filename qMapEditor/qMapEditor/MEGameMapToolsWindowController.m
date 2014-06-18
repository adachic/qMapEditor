//
//  MEGameMapToolsWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGameMapToolsWindowController.h"
#import "METileView.h"

@interface MEGameMapToolsWindowController ()

@end

@implementation MEGameMapToolsWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (void)showParhapsSize:(CGFloat)x y:(CGFloat)y t:(CGFloat)t
{
    self.tfParhaps.stringValue = [NSString stringWithFormat:@"x:%.0f,y:%.0f,t:%.0f",x,y,t];
}

- (IBAction)clickedAspectFix:(id)sender {
    self.aspectT = [self.tfAspectT.stringValue floatValue];
    self.aspectX = [self.tfAspectX.stringValue floatValue];
    self.aspectY = [self.tfAspectY.stringValue floatValue];

    //todo境界値チェック
    [self drawTile];
}

- (void)drawTile {
    METileView *tileView = [[METileView alloc]
            initWithAspectX:self.aspectX aspectY:self.aspectY aspectT:self.aspectT frame:self.sampleTileView.frame];

    for (NSView *view in [self.sampleTileView.subviews mutableCopy]) {
        [view removeFromSuperview];
    }

    [self.sampleTileView addSubview:tileView];

    [tileView drawLine];
}

@end
