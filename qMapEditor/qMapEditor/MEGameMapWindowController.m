//
//  MEGameMapWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGameMapWindowController.h"
#import "MEMatrix.h"
#import "MEGameMapChipLayer.h"
#import "MEGameParts.h"

@interface MEGameMapWindowController ()
@end

@implementation MEGameMapWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName
                    fileURL:(NSURL *)url
                       maxM:(MEMatrix *)maxSize
                    aspectX:(CGFloat)x
                    aspectY:(CGFloat)y
                    aspectT:(CGFloat)t {
    NSLog(@"init");
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        [self.window setDelegate:self];

        _maxM = maxSize;

        _shouldShowGriph = YES;
        _shouldShowLines = YES;
        _shouldShowUpper = YES;

        _aspectX = x;
        _aspectY = y;
        _aspectT = t;

        _currentCursor = [[MEMatrix alloc] initWithX:0 Y:0 Z:0];

        [self makeJungleJym];
        [self showTargetView];
    }
    return self;
}

- (int)makeTagWithX:(int)x y:(int)y z:(int)z {
    return x + y * 100 + z * 10000;
}

//新規のジャングルジム生成
- (void)makeJungleJym {
    self.jungleJym = [NSMutableDictionary dictionary];
    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            for (int z = 0; z < self.maxM.z; z++) {
                int tag = [self makeTagWithX:x y:y z:z];
                //  self.jungleJym[[NSString stringWithFormat:@"%d", tag]] = nil;
            }
        }
    }
}

//ツールバーのfixを押した
- (void)fixedValuesFromToolBar:(MEMatrix *)maxM x:(CGFloat)x y:(CGFloat)y t:(CGFloat)t {
    _maxM = maxM;
    _aspectX = x;
    _aspectY = y;
    _aspectT = t;
    [self showTargetView];
}

//ツールバーに反映
- (void)windowDidBecomeKey:(NSNotification *)notification {
    NSLog(@"map window become-- %@", notification);
    if (self.onSetToToolWindow) {
        self.onSetToToolWindow(self.maxM, self.aspectX, self.aspectY, self.aspectT);
    }
}

//ウィンドウサイズ、viewサイズの初期化
- (void)showTargetView {
    [self clear];
    [self showBackground];
    [self showTiles];
}

- (void)clear {
    for (CALayer *subLayer in [self.targetView.layer.sublayers mutableCopy]) {
        [subLayer removeFromSuperlayer];
    }
}

//タイルの描画
- (void)showTiles {
    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            for (int z = 0; z < self.maxM.z; z++) {
                int tag = [self makeTagWithX:x y:y z:z];
                MEGameParts *cube = self.jungleJym[[NSString stringWithFormat:@"%d", tag]];

                MEGameMapChipLayer *chip = [[MEGameMapChipLayer alloc] initWithGameParts:cube
                                                                                       x:self.aspectX
                                                                                       y:self.aspectY
                                                                                       t:self.aspectT];
                CGFloat xOrigin = self.aspectX / 2.0f * x +
                        self.aspectX / 2.0f * y;
                CGFloat yOrigin =
                        self.aspectY / 2.0f * x * -1.0f +
                                self.aspectY / 2.0f * y +
                                self.aspectT * z;
                CGFloat yAid =
                        self.aspectY / 2.0f * self.maxM.x;
                [chip setFrame:CGRectMake(xOrigin, yOrigin + yAid, chip.bounds.size.width, chip.bounds.size.height)];
                [self.targetView.layer addSublayer:chip];
                if (!cube && self.currentCursor.z == z) {
                    if (self.currentCursor.x == x &&
                        self.currentCursor.y == y &&
                        self.currentCursor.z == z) {
                        [chip drawCurrentCursor];
                        continue;
                    }
                    //空四角形を描画
                    [chip drawEmptyCursor];
                    continue;
                }
            }
        }
    }
}


- (void)showBackground {
    CGFloat width =
            self.aspectX / 2.0f +
                    self.aspectX / 2.0f * self.maxM.x +
                    self.aspectY / 2.0f * self.maxM.y;
    CGFloat height =
            self.aspectY / 2.0f * self.maxM.x +
                    self.aspectY + self.aspectY / 2.0f * self.maxM.y +
                    self.aspectT * self.maxM.z;
    NSLog(@"unko2 %f,%f", width, height);

    CGRect winsize = CGRectMake(0, 0, width, height);
    [self.targetView setFrame:winsize];
    [self.targetView setWantsLayer:YES];
    self.targetView.layer.backgroundColor = [[NSColor blackColor] CGColor];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

}

@end
