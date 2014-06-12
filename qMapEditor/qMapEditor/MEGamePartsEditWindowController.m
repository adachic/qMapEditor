//
//  MEGamePartsEditWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsEditWindowController.h"
#import "MEGameParts.h"
#import "MEAnimationBaseView.h"
#import <QuartzCore/QuartzCore.h>

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

- (void)runAnimation {
//    [CATransaction begin];
    [self.topImageView setWantsLayer:YES];

    CALayer* animationLayer = [CALayer layer];
    animationLayer.frame = self.topImageView.bounds;
    [self.topImageView.layer addSublayer:animationLayer];
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    NSMutableArray *array = [NSMutableArray array];
    CGImageRef maskRef;
    for (METile *tile in buildingGameParts.tiles) {
        NSImage *someImage = [tile image];
        CGImageSourceRef source;
        source = CGImageSourceCreateWithData((__bridge CFDataRef) [someImage TIFFRepresentation], NULL);
        maskRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        [array addObject:(__bridge id) (maskRef)];
    }
    
    NSLog(@"array:%@",array);
    keyAnimation.values = (NSArray*)array;
    keyAnimation.duration = 1.0f;
    keyAnimation.repeatCount = HUGE_VALF;
    [keyAnimation setCalculationMode: kCAAnimationDiscrete];

    [animationLayer addAnimation:keyAnimation forKey:@"aho"];
//    [CATransaction commit];
}

//セットアップ
- (void)setViewWithGameParts:(MEGameParts *)gameParts {
    NSAssert(gameParts, @"gameParts should not nil");
    buildingGameParts = nil;
    buildingGameParts = gameParts;

    int i = 0;
    for (CALayer *layer in [self.topImageView.layer.sublayers mutableCopy]){
        [layer removeAllAnimations];
//        [layer removeFromSuperlayer];
    }
    for (NSView *subView in [self.animationViewBase.subviews mutableCopy]) {
        NSLog(@"idx1:%d", i++);
        [subView removeFromSuperview];
    }
    if ([buildingGameParts.tiles count] > 1) {
        //アニメーションあり
        int idx = 0;
        for (METile *tile in buildingGameParts.tiles) {
            NSLog(@"idx:%d", idx);
            CGFloat widthVolume = 50.0f;
            CGFloat heightVolume = 50.0f;
            NSImageView *imageView = [[NSImageView alloc]
                    initWithFrame:CGRectMake(widthVolume * (idx % 5), heightVolume * (idx / 5), widthVolume, heightVolume)];
            [imageView setImage:[tile image]];
            [self.animationViewBase addSubview:imageView];
            idx++;
        }
        [self runAnimation];
    } else {
        NSLog(@"updated imageView");
        [self.topImageView setImage:[buildingGameParts image]];
        [buildingGameParts initSampleImageWithKVO:NO];
    }

    buildingGameParts.walkable = [self.walkable state] == NSOnState;
//    [buildingGameParts.sampleImage setImage:[_topImageView image]];

    NSLog(@"topImageView  id;%@ %@", self.topImageView, self.topImageView.image);
}

//タイルが指定された
- (void)setViewWithTile:(METile *)tile {
//    NSAssert(tile, @"tile should not nil");
    NSMutableArray *tiles = [[NSMutableArray alloc] initWithArray:buildingGameParts.tiles];
    [tiles addObject:tile];

    if (!buildingGameParts) {
        buildingGameParts = [[MEGameParts alloc] initWithTiles:tiles
                                                      walkable:YES
                                                      duration:0
                                                  customEvents:nil];
    }

    if (self.animationViewBase.editable) {
        buildingGameParts.tiles = nil;
        buildingGameParts.tiles = tiles;
    } else {
        buildingGameParts.tiles = nil;
        buildingGameParts.tiles = [NSMutableArray arrayWithObjects:tile, nil];
    }

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

//animボタン
- (IBAction)pushedSwitchAnimMode:(id)sender {
    [self.animationViewBase switchMode];
    if (self.animationViewBase.editable) {
        [self.modeLabel setStringValue:@"Select any tile to add animation."];
    } else {
        [self.modeLabel setStringValue:@"disable"];
    }
}

//clearボタン
- (IBAction)pushedClearAnim:(id)sender {

}


@end
