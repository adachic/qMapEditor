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
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

        // 通知センターに通知要求を登録する
        // この例だと、通知センターに"Tuchi"という名前の通知がされた時に、
        // hogeメソッドを呼び出すという通知要求の登録を行っている。
        [nc addObserver:self selector:@selector(selectedGameParts:) name:@"selectedGameParts" object:nil];
    }
    return self;
}

#ifdef NEVER
- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
#endif

/* todo:がんばれよ
- (void)animateImageView:(NSImageView *)newImageView;
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration: 2];
    [[newImageView animator] setAlphaValue: 1];
    [[imageView animator] setAlphaValue: 0];
    [NSAnimationContext endGrouping];
}
*/


//セットアップ
- (void)setViewWithGameParts:(MEGameParts *)gameParts {
    //   NSLog(@"setTopViewWithImage:size:%f,%f :%@:%@:%@", tile.size.width, tile.size.height, self.topImageView, self.topView, tile);
    NSAssert(gameParts, @"gameParts should not nil");
    buildingGameParts = gameParts;

    if ([buildingGameParts.tiles count] > 1) {
        //アニメーションあり
        // [self animate];
        buildingGameParts.tiles = nil ;
        buildingGameParts.tiles = gameParts.tiles;
    } else {
        [self.topImageView setImage:[buildingGameParts image]];
    }

    buildingGameParts.walkable = [self.walkable state] == NSOnState;
    [buildingGameParts.sampleImage setImage:[buildingGameParts image]];

    NSLog(@"topImageView  id;%@ %@", self.topImageView, self.topImageView.image);
}

//タイルが指定された
- (void)setViewWithTile:(METile *)tile {
    NSAssert(tile, @"tile should not nil");
    NSArray *tiles = [[NSArray alloc] initWithObjects:tile, nil];
    if (!buildingGameParts) {
        buildingGameParts = [[MEGameParts alloc] initWithTiles:tiles
                                                      walkable:YES
                                                      duration:0
                                                  customEvents:nil];
        [self setViewWithGameParts:buildingGameParts];
        return;
    }
    buildingGameParts.tiles = nil;
    buildingGameParts.tiles = tiles;

    [self setViewWithGameParts:buildingGameParts];
}


//リストから選択された
- (void)selectedGameParts:(id)obj {
    NSDictionary *dict = [[obj userInfo] objectForKey:@"KEY"];
    MEGameParts *parts = [dict objectForKey:@"game_parts"];
    NSLog(@"selectedGameParts,%@", parts);

    [self setViewWithGameParts:parts];
}

//Addボタン：GameParts追加
- (IBAction)pushedAddGameParts:(id)sender {
    NSLog(@"topImageView2 id;%@ %@", self.topImageView, self.topImageView.image);
    self.onRegistGameParts([buildingGameParts copy]);
}

//Modifyボタン：GameParts上書き
- (IBAction)pushedModifyGameParts:(id)sender {
    MEGameParts *gameParts = [buildingGameParts copy];
    self.onUpdateGameParts(gameParts);
}

//deleteボタン：GameParts削除
- (IBAction)pushedDeleteGameParts:(id)sender {
    self.onDeleteGameParts();
}
//GamePartsロード




@end
