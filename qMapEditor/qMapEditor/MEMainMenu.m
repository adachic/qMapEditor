//
//  MEMainMenu.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEMainMenu.h"
#import "METileWindowController.h"
#import "MEEditSet.h"
#import "MEGameMapWindowController.h"
#import "MEMatrix.h"

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
        self.gameMapToolsWindowController =
                (MEGameMapToolsWindowController *) [self loadFromNibWithNibNamed:@"MEGameMapToolsWindowController"];
    }
    self.tileWindowControllers = [NSMutableArray new];
    self.mapWindowControllers = [NSMutableArray new];
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

    //toolにparhapsを表示
    self.gamePartsEditWindowController.onSelectedGameParts = [^(MEGameParts *gameParts) {
        METile *sample = [gameParts.tiles lastObject];
        [blockself.gameMapToolsWindowController showParhapsSize:sample.tileRect.size.width
                                                              y:sample.tileRect.size.height / 2.0f
                                                              t:sample.tileRect.size.height / 2.0f];

    } copy];

    //先頭のMapwindowにToolsの値を反映させる
    self.gameMapToolsWindowController.onSetToMapWindow = [^(MEMatrix *_maxM, CGFloat _x, CGFloat _y, CGFloat _t) {
        NSLog(@"ahoaho");
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front fixedValuesFromToolBar:_maxM x:_x y:_y t:_t];
    } copy];

    self.gameMapToolsWindowController.onMaxXModifyToMapWindow = [^(BOOL shouldUp) {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front modifyMaxX:shouldUp];
    } copy];

    self.gameMapToolsWindowController.onMaxYModifyToMapWindow = [^(BOOL shouldUp) {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front modifyMaxY:shouldUp];
    } copy];

    self.gameMapToolsWindowController.onMaxZModifyToMapWindow = [^(BOOL shouldUp) {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front modifyMaxZ:shouldUp];
    } copy];

    self.gameMapToolsWindowController.onCursorZModifyToMapWindow = [^(BOOL shouldUp) {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front modifyCursorZ:shouldUp];
    } copy];

    self.gameMapToolsWindowController.onSwitchPenToMapWindow = [^(int penSize) {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front switchToPenMode:penSize];
    } copy];

    self.gameMapToolsWindowController.onSwitchEraserToMapWindow = [^(int eraseSize) {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front switchToEraserMode:eraseSize];
    } copy];

    self.gameMapToolsWindowController.onFillLayerToMapWindow = [^() {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front fillLayer];
    } copy];

    self.gameMapToolsWindowController.onClearLayerToMapWindow = [^() {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front clearLayer];
    } copy];

    self.gameMapToolsWindowController.onShiftUpZMapWindow = [^() {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front shiftUpZ];
    } copy];

    /*ツールウィンドウのコールバック*/
    return self;
}

//一番手前にあるMapを取り出す
- (MEGameMapWindowController *)frontGameMapWindowController {
    MEGameMapWindowController *front = nil;
    for (MEGameMapWindowController *mw in self.mapWindowControllers) {
        int min = 9999;
        //一番低いやつが先頭
        if (mw.window.orderedIndex < min) {
            min = mw.window.orderedIndex;
            front = mw;
        }
    }
    return front;
}

- (BOOL)validateMenuItem:(id)menuItem {
    return YES;
}


#pragma mark create_window

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

/*マップウィンドウ生成*/
- (void)createGameMapWindow:(NSURL *)filePath {
    MEGameMapWindowController *w = [[MEGameMapWindowController alloc]
            initWithWindowNibName:@"MEGameMapWindowController"
                          fileURL:filePath
                             maxM:self.gameMapToolsWindowController.maxM
                          aspectX:self.gameMapToolsWindowController.aspectX
                          aspectY:self.gameMapToolsWindowController.aspectY
                          aspectT:self.gameMapToolsWindowController.aspectT
                        jungleGym:nil
                selectedGameParts:[self.gamePartsListWindowController.gamePartsViewController selectedGameParts]
    ];
    w.onSetToToolWindow = [^(MEMatrix *_maxM, CGFloat _x, CGFloat _y, CGFloat _t, MEMatrix *cursor) {
        [self.gameMapToolsWindowController changedMapWindow:_maxM
                                                          x:_x
                                                          y:_y
                                                          t:_t
                                                     cursor:cursor];
    } copy];

    [w.window makeKeyAndOrderFront:nil];
    [self.mapWindowControllers addObject:w];
}

/*編集関係の復元*/
- (void)restoreGamePartsListWindows:(NSMutableArray *)gamePartsArray tileSheets:(NSMutableArray *)tileSheets {
    //タイルウィンドウの復元
    [self.tileWindowControllers removeAllObjects];
    for (NSDictionary *tileDict in tileSheets) {
        METileWindowController *w = [[METileWindowController alloc]
                initWithWindowNibName:@"METileWindowController"
                             imageURL:[tileDict objectForKey:@"filePath"]
                             widthNum:((NSNumber *) [tileDict objectForKey:@"widthNum"]).integerValue
                            heightNum:((NSNumber *) [tileDict objectForKey:@"heightNum"]).integerValue
                             onPickUp:^(METile *tile) {
                                 [self.gamePartsEditWindowController setViewWithTile:tile];
                             }];
        [w.window makeKeyAndOrderFront:nil];
        [w drawLineAfterLoad];
        [self.tileWindowControllers addObject:w];
    }
    //リストウィンドウの復元
    self.gamePartsListWindowController.gamePartsViewController.gamePartsArray = gamePartsArray;
}

//マップの復元
- (void)restoreMapWindow:(NSMutableArray *)gamePartsArray
              tileSheets:(NSMutableArray *)tileSheets
                 mapInfo:(NSMutableDictionary *)mapInfo
                filePath:(NSURL *)filePath {
    __block MEMainMenu *blockself = self;
    [self restoreGamePartsListWindows:gamePartsArray
                           tileSheets:tileSheets];
    //マップの復元
    MEGameMapWindowController *w = [[MEGameMapWindowController alloc]
            initWithWindowNibName:@"MEGameMapWindowController"
                          fileURL:filePath
                             maxM:[[MEMatrix alloc] initWithX:[mapInfo[@"maxX"] integerValue]
                                                            Y:[mapInfo[@"maxY"] integerValue]
                                                            Z:[mapInfo[@"maxZ"] integerValue]]
                          aspectX:[mapInfo[@"aspectX"] floatValue]
                          aspectY:[mapInfo[@"aspectY"] floatValue]
                          aspectT:[mapInfo[@"aspectT"] floatValue]
                        jungleGym:mapInfo[@"jungleGym"]
                selectedGameParts:[self.gamePartsListWindowController.gamePartsViewController selectedGameParts]
    ];
    w.onSetToToolWindow = [^(MEMatrix *_maxM, CGFloat _x, CGFloat _y, CGFloat _t, MEMatrix *cursor) {
        [blockself.gameMapToolsWindowController changedMapWindow:_maxM
                                                               x:_x
                                                               y:_y
                                                               t:_t
                                                          cursor:cursor];
    } copy];
    [w.window makeKeyAndOrderFront:nil];
    [self.mapWindowControllers addObject:w];
}

#pragma mark IBActions

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

/*ゲームマップウィンドウを開く*/
- (IBAction)openGameMapWindow:(id)sender {
    __block MEMainMenu *blockself = self;
    /*Openダイアログを表示*/
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"mdat", nil];
    [openPanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [openPanel runModal];

    // NSLog(@"id:%@", self.gamePartsEditWindowController);
    if (pressedButton == NSOKButton) {
        NSURL *filePath = [openPanel URL];
        NSLog(@"file opened %@", filePath);
        [MEEditSet loadMapFromFile:filePath
                          complete:^(
                                  NSMutableArray *gamePartsArray,
                                  NSMutableArray *tileSheets,
                                  NSMutableDictionary *mapInfo
                          ) {
                              [blockself restoreMapWindow:gamePartsArray
                                               tileSheets:tileSheets
                                                  mapInfo:mapInfo
                                                 filePath:filePath
                              ];
                          }];
    }
}

- (IBAction)newGameMapWindow:(id)sender {
    [self createGameMapWindow:nil];
}

//ゲームマップを保存
- (IBAction)saveGameMapWindow:(id)sender {
    /*Saveダイアログを表示*/
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"mdat", nil];
    [savePanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [savePanel runModal];

    if (pressedButton == NSOKButton) {
        NSURL *filePath = [savePanel URL];
        NSLog(@"file saved %@", filePath);
        /*シリアライズして保存*/
        [MEEditSet saveGameMapWithPath:filePath
                 tileWindowControllers:self.tileWindowControllers
         gamePartsListWindowController:self.gamePartsListWindowController
               gameMapWindowController:[self frontGameMapWindowController]
        ];
    }

}

/*GamePartsListを保存*/
- (IBAction)saveGamePartsListFile:(id)sender {
    /*Saveダイアログを表示*/
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"pdat", nil];
    [savePanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [savePanel runModal];

    if (pressedButton == NSOKButton) {
        NSURL *filePath = [savePanel URL];
        NSLog(@"file saved %@", filePath);
        /*シリアライズして保存*/
        //todo:ファイル名保存
        [MEEditSet saveGamePartsListWithPath:filePath
                       tileWindowControllers:self.tileWindowControllers
               gamePartsListWindowController:self.gamePartsListWindowController];
    }
}

/*GamePartsListをロード*/
- (IBAction)openGamePartsListFile:(id)sender {
    __block MEMainMenu *blockself = self;
    /*Openダイアログを表示*/
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"pdat", nil];
    [openPanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [openPanel runModal];

    NSLog(@"id:%@", self.gamePartsEditWindowController);
    if (pressedButton == NSOKButton) {
        NSURL *filePath = [openPanel URL];
        NSLog(@"file opened %@", filePath);
        [MEEditSet loadEditSetFromFile:filePath
                              complete:^(NSMutableArray *gamePartsArray, NSMutableArray *tileSheets) {
                                  [blockself restoreGamePartsListWindows:gamePartsArray tileSheets:tileSheets];
                              }];
    }
}

//Mapをjsonとしてexportする
- (IBAction)exportGameMapWindow:(id)sender {
    /*Saveダイアログを表示*/
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"map", nil];
    [savePanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [savePanel runModal];

    if (pressedButton == NSOKButton) {
        NSURL *filePath = [savePanel URL];
        NSLog(@"file saved %@", filePath);
        /*jsonシリアライズして保存*/
        [MEEditSet saveMapJsonWithPath:filePath
                   mapWindowController:[self frontGameMapWindowController]];
    }

}


- (IBAction)syncToGameParts:(id)menuItem{
    MEGameMapWindowController *front = [self frontGameMapWindowController];
    if(!front){
        return;
    }
    
    for (int x = 0; x < front.maxM.x; x++) {
        for (int y = 0; y < front.maxM.y; y++) {
            for (int z = 0; z < front.maxM.z; z++) {
                MEGameParts * cube = [front.jungleJym objectForKey:[front makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                    Y:y
                                                                                                    Z:z]]];
                
                if(!cube){
                    continue;
                }

                MEGameParts * cube2 = [self.gamePartsListWindowController.gamePartsViewController searchItemWithName:cube.name];
                if (!cube2) {
                    NSLog(@"name:%@ is nil. skip.",cube.name);
                    continue;
                    
                }
                [front.jungleJym setObject:cube2 forKey:[front makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                Y:y
                                                                                                          Z:z]]];
            }
        }
    }
    [front syncToGameParts];
}
@end
