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
                    fileURL:(NSURL *)url {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        _maxM = [[MEMatrix alloc] initWithX:10 Y:10 Z:10];
        _shouldShowGriph = YES;
        _shouldShowLines = YES;
        _shouldShowUpper = YES;
    }
    return self;
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
