//
//  MEMainMenu.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEMainMenu.h"
#import "METileWindowController.h"

@implementation MEMainMenu

- (id)loadFromNibWithNibNamed:(NSString *)nameOfNib {
    NSArray *topLevel = [NSArray new];
    if (![[NSBundle mainBundle] loadNibNamed:nameOfNib owner:nil topLevelObjects:&topLevel]) {
        NSAssert(false, @"FAIL bundle load %@", nameOfNib);
        return self;
    }
    for (id obj in topLevel) {
        if (NSClassFromString(nameOfNib) == [obj class]) {
            return obj;
        }
    }
    NSAssert(false, @"FAIL bundle load 2 %@", nameOfNib);
    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        self.gamePartsEditWindowController =
                (MEGamePartsEditWindowController *) [self loadFromNibWithNibNamed:@"MEGamePartsEditWindowController"];
        self.gamePartsListWindowController =
                (MEGamePartsListWindowController *) [self loadFromNibWithNibNamed:@"MEGamePartsListWindowController"];
    }

    self.tileWindowControllers = [NSMutableArray new];
    __block MEMainMenu *blockself = self;

    /*編集ウィンドウ:ボタンのコールバック*/
    self.gamePartsEditWindowController.onRegistGameParts = [^(MEGameParts *gameParts) {
        [blockself.gamePartsListWindowController.gamePartsViewController addGameParts:gameParts];
    } copy];

    self.gamePartsEditWindowController.onUpdateGameParts = [^(MEGameParts *gameParts) {
        [blockself.gamePartsListWindowController.gamePartsViewController updateGameParts:gameParts];
    } copy];

    self.gamePartsEditWindowController.onDeleteGameParts = [^() {
        [blockself.gamePartsListWindowController.gamePartsViewController deleteGameParts];
    } copy];

    return self;
}

- (BOOL)validateMenuItem:(id)menuItem {
    return YES;
}


/*タイルマップウィンドウ生成*/
- (void)createTileWindow:(NSURL *)filePath {
    METileWindowController *w = [[METileWindowController alloc]
            initWithWindowNibName:@"METileWindowController"
                         imageURL:filePath
                         onPickUp:^(METile *tile) {
                             [self.gamePartsEditWindowController setViewWithTile:tile];
                         }];
    [w.window makeKeyAndOrderFront:nil];
    [self.tileWindowControllers addObject:w];

}

/*ゲームパーツ編集ウィンドウの表示*/
- (IBAction)showGameParts:(id)sender {
    [self.gamePartsEditWindowController.window orderFront:self];
}

/*タイルマップを開く*/
- (IBAction)openTileFile:(id)sender {
    /*Openダイアログを表示*/
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"png", @"jpg", @"bmp", nil];
    [openPanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [openPanel runModal];

    NSLog(@"id:%@", self.gamePartsEditWindowController);
    if (pressedButton == NSOKButton) {
        NSURL *filePath = [openPanel URL];
        NSLog(@"file opened %@", filePath);
        /*タイルウィンドウを表示*/
        [self createTileWindow:filePath];
    }
}
@end
