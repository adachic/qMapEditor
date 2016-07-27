//
//  MEGameMapToolsWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGameMapToolsWindowController.h"
#import "METileView.h"
#import "MEMatrix.h"


@interface MEGameMapToolsWindowController ()

@end

@implementation MEGameMapToolsWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        [self.window setDelegate:self];
        self.maxM = [[MEMatrix alloc] initWithX:10 Y:10 Z:10];
        [self.buttonEraser setWantsLayer:YES];
        [self.buttonPen setWantsLayer:YES];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)showParhapsSize:(CGFloat)x y:(CGFloat)y t:(CGFloat)t {
    self.tfParhaps.stringValue = [NSString stringWithFormat:@"x:%.0f,y:%.0f,t:%.0f", x, y, t];
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    NSLog(@"test3 %@", notification);
}

- (void)changedMapWindow:(MEMatrix *)maxM x:(CGFloat)x y:(CGFloat)y t:(CGFloat)t cursor:(MEMatrix *)cursor {
    self.aspectX = x;
    self.aspectY = y;
    self.aspectT = t;
    self.maxM = maxM;
    [self.tfAspectX setStringValue:[NSString stringWithFormat:@"%.0f", x]];
    [self.tfAspectY setStringValue:[NSString stringWithFormat:@"%.0f", y]];
    [self.tfAspectT setStringValue:[NSString stringWithFormat:@"%.0f", t]];
    [[self tfMaxX] setStringValue:[NSString stringWithFormat:@"%d", self.maxM.x]];
    [[self tfMaxY] setStringValue:[NSString stringWithFormat:@"%d", self.maxM.y]];
    [[self tfMaxZ] setStringValue:[NSString stringWithFormat:@"%d", self.maxM.z]];
    [[self tfCursorZ] setStringValue:[NSString stringWithFormat:@"z:%d/%d", cursor.z, self.maxM.z]];
    [self drawTile];

    NSLog(@"changedMapWindow");
}


- (IBAction)clickedAspectFix:(id)sender {
    self.aspectT = [self.tfAspectT.stringValue floatValue];
    self.aspectX = [self.tfAspectX.stringValue floatValue];
    self.aspectY = [self.tfAspectY.stringValue floatValue];

    //マップに反映
    if (self.onSetToMapWindow) {
        self.onSetToMapWindow(self.maxM, self.aspectX, self.aspectY, self.aspectT);
    }

    //todo:境界値チェック

    //サンプルビュー描画
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

- (IBAction)clickdMaxXUpper:(id)sender {
    if (self.onMaxXModifyToMapWindow) {
        self.onMaxXModifyToMapWindow(YES);
    }
}

- (IBAction)clickdMaxYUpper:(id)sender {
    if (self.onMaxYModifyToMapWindow) {
        self.onMaxYModifyToMapWindow(YES);
    }
}

- (IBAction)clickdMaxXDowner:(id)sender {
    if (self.onMaxXModifyToMapWindow) {
        self.onMaxXModifyToMapWindow(NO);
    }
}

- (IBAction)clickdMaxYDowner:(id)sender {
    if (self.onMaxYModifyToMapWindow) {
        self.onMaxYModifyToMapWindow(NO);
    }
}

- (IBAction)clickdMaxZUpper:(id)sender {
    if (self.onMaxZModifyToMapWindow) {
        self.onMaxZModifyToMapWindow(YES);
    }
}

- (IBAction)clickdMaxZDowner:(id)sender {
    if (self.onMaxZModifyToMapWindow) {
        self.onMaxZModifyToMapWindow(NO);
    }
}

- (IBAction)clickdUpButton:(id)sender {
    if (self.onCursorZModifyToMapWindow) {
        self.onCursorZModifyToMapWindow(YES);
    }
}

- (IBAction)clickdDownButton:(id)sender {
    if (self.onCursorZModifyToMapWindow) {
        self.onCursorZModifyToMapWindow(NO);
    }
}

- (IBAction)clickdPutFlagAllyButton:(id)sender {
    if (self.onSwitchPutFlagAllyToMapWindow) {
        self.onSwitchPutFlagAllyToMapWindow();
    }
}

- (IBAction)clickdPutFlagEnemyButton:(id)sender {
    if (self.onSwitchPutFlagEnemyToMapWindow) {
        self.onSwitchPutFlagEnemyToMapWindow();
    }
}

- (IBAction)clickdEraseFlagEnemyButton:(id)sender {
    if (self.onSwitchEraseFlagEnemyToMapWindow) {
        self.onSwitchEraseFlagEnemyToMapWindow();
    }
}

- (IBAction)clickdClearFlagEnemyButton:(id)sender {
    if (self.onClearFlagEnemyToMapWindow) {
        self.onClearFlagEnemyToMapWindow();
    }
}


- (IBAction)clickdPen1Button:(id)sender {
    if (self.onSwitchPenToMapWindow) {
        self.buttonPen.layer.backgroundColor = [[NSColor greenColor] CGColor];
        self.buttonEraser.layer.backgroundColor = [[NSColor clearColor] CGColor];
        self.onSwitchPenToMapWindow(1);
    }
}

- (IBAction)clickdPen2Button:(id)sender {
    if (self.onSwitchPenToMapWindow) {
        self.buttonPen.layer.backgroundColor = [[NSColor greenColor] CGColor];
        self.buttonEraser.layer.backgroundColor = [[NSColor clearColor] CGColor];
        self.onSwitchPenToMapWindow(2);
    }
}

- (IBAction)clickdPen3Button:(id)sender {
    if (self.onSwitchPenToMapWindow) {
        self.buttonPen.layer.backgroundColor = [[NSColor greenColor] CGColor];
        self.buttonEraser.layer.backgroundColor = [[NSColor clearColor] CGColor];
        self.onSwitchPenToMapWindow(3);
    }
}

- (IBAction)clickdEraser1Button:(id)sender {
    if (self.onSwitchEraserToMapWindow) {
        self.buttonEraser.layer.backgroundColor = [[NSColor greenColor] CGColor];
        self.buttonPen.layer.backgroundColor = [[NSColor clearColor] CGColor];
        self.onSwitchEraserToMapWindow(1);
    }
}
- (IBAction)clickdEraser2Button:(id)sender {
    if (self.onSwitchEraserToMapWindow) {
        self.buttonEraser.layer.backgroundColor = [[NSColor greenColor] CGColor];
        self.buttonPen.layer.backgroundColor = [[NSColor clearColor] CGColor];
        self.onSwitchEraserToMapWindow(2);
    }
}
- (IBAction)clickdEraser3Button:(id)sender {
    if (self.onSwitchEraserToMapWindow) {
        self.buttonEraser.layer.backgroundColor = [[NSColor greenColor] CGColor];
        self.buttonPen.layer.backgroundColor = [[NSColor clearColor] CGColor];
        self.onSwitchEraserToMapWindow(2);
    }
}
- (IBAction)clickdFillLayerButton:(id)sender {
    if (self.onFillLayerToMapWindow) {
        self.onFillLayerToMapWindow();
    }
}

- (IBAction)clickdClearLayerButton:(id)sender {
    if (self.onClearLayerToMapWindow) {
        self.onClearLayerToMapWindow();
    }
}

- (IBAction)clickdShiftUpZButton:(id)sender{
    if (self.onShiftUpZMapWindow) {
        self.onShiftUpZMapWindow();
    }
}
@end
