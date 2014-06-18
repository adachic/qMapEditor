//
//  MEGameMapWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGameMapWindowController.h"
#import "MEMatrix.h"

@interface MEGameMapWindowController ()
@end

@implementation MEGameMapWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName
                    fileURL:(NSURL *)url
                       maxM:(MEMatrix *)maxSize
                    aspectX:(CGFloat)x
                    aspectY:(CGFloat)y
                    aspectT:(CGFloat)t {
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
    }
    return self;
}

- (void)fixedValuesFromToolBar:(MEMatrix *)maxM x:(CGFloat)x y:(CGFloat)y t:(CGFloat)t{
    _maxM = maxM;
    _aspectX = x;
    _aspectY = y;
    _aspectT = t;
}

//ツールバーに反映
- (void)windowDidBecomeKey:(NSNotification *)notification {
    NSLog(@"test-- %@", notification);
    if (self.onSetToToolWindow) {
        self.onSetToToolWindow(self.maxM, self.aspectX, self.aspectY, self.aspectT);
    }
}

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    //ウィンドウサイズ、viewサイズの初期化



    // 背景グラデーション

    // ライン表示

    //
}

@end
