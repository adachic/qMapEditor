//
//  MEGamePartsEditWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsEditWindowController.h"
#import "MEGameParts.h"

@interface MEGamePartsEditWindowController ()

@end

@implementation MEGamePartsEditWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
//        self.topImageView = [[NSImageView alloc] initWithFrame:self.topView.bounds];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

//タイルセットピックアップ
- (void)setTopViewWithImage:(NSImage *)tile {
    //   NSLog(@"setTopViewWithImage:size:%f,%f :%@:%@:%@", tile.size.width, tile.size.height, self.topImageView, self.topView, tile);
    [self.topImageView setImage:tile];
    NSLog(@"topImageView  id;%@ %@",self.topImageView, self.topImageView.image);
}

//GameParts追加
- (IBAction)pushedAddGameParts:(id)sender {
    NSLog(@"topImageView2 id;%@ %@",self.topImageView, self.topImageView.image);
    MEGameParts *gameParts = [[MEGameParts alloc] initWithParams:YES
                                                       imageView:self.topImageView
                                                    customEvents:nil];
    NSLog(@"topImageView3 id;%@ %@",gameParts.imageView, gameParts.imageView.image);
    self.onRegistGameParts(gameParts);
}

//GamePartsロード

//GameParts上書き
- (IBAction)pushedModifyGameParts:(id)sender {

}

//GameParts削除
- (IBAction)pushedDeleteGameParts:(id)sender {

}


@end
