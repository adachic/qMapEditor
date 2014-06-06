//
//  MEGamePartsEditWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsEditWindowController.h"

@interface MEGamePartsEditWindowController ()

@end

@implementation MEGamePartsEditWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        self.topImageView = [[NSImageView alloc] initWithFrame:self.topView.bounds];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

//タイルセットピックアップ
- (void)setTopViewWithImage:(NSImage *)tile {
    NSLog(@"size:%f,%f :%@:%@:%@",tile.size.width,tile.size.height,self.topImageView,self.topView,tile);
    [self.topImageView setImage:tile];
}



//GameParts追加

//GamePartsロード

//GameParts上書き

//GameParts削除


@end
