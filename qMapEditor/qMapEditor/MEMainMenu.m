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

@interface MEMainMenu ()
@property NSMutableArray *gamePartsListWindowControllers;
@end

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
        [self.gamePartsEditWindowController.window setTitle:@"edit"];

        self.gamePartsListWindowControllers = [@[] mutableCopy];
        for (NSString *categoryName in [MECategory existCategories]) {
            [self createListWindow:categoryName];
        }

        self.gameMapToolsWindowController =
                (MEGameMapToolsWindowController *) [self loadFromNibWithNibNamed:@"MEGameMapToolsWindowController"];
    }
    self.tileWindowControllers = [NSMutableArray new];
    self.mapWindowControllers = [NSMutableArray new];
    __block MEMainMenu *blockself = self;

    /*編集ウィンドウ:ボタンのコールバック*/
    self.gamePartsEditWindowController.onRegistGameParts = [^(MEGameParts *gameParts) {
        for (MEGamePartsListWindowController *wc in blockself.gamePartsListWindowControllers) {
            [wc addGameParts:gameParts];
        }
    } copy];

    self.gamePartsEditWindowController.onUpdateGameParts = [^(MEGameParts *gameParts) {
        for (MEGamePartsListWindowController *wc in blockself.gamePartsListWindowControllers) {
            [wc updateGameParts:gameParts];
        }
    } copy];

    self.gamePartsEditWindowController.onDeleteGameParts = [^() {
        [[blockself frontGamePartsListWindowController] deleteGameParts];
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
    
    
    self.gameMapToolsWindowController.onSwitchPutFlagAllyToMapWindow = [^() {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front putAllyFlag];
    } copy];
    
    self.gameMapToolsWindowController.onSwitchPutFlagEnemyToMapWindow = [^() {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front putEnemyFlag];
    } copy];
    
    self.gameMapToolsWindowController.onSwitchEraseFlagEnemyToMapWindow = [^() {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front eraseEnemyFlag];
    } copy];

    self.gameMapToolsWindowController.onClearFlagEnemyToMapWindow = [^() {
        MEGameMapWindowController *front = [blockself frontGameMapWindowController];
        [front clearEnemyFlag];
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

//一番手前にあるListWindowを取り出す
- (MEGamePartsListWindowController *)frontGamePartsListWindowController {
    MEGamePartsListWindowController *front = nil;
    for (MEGamePartsListWindowController *mw in self.gamePartsListWindowControllers) {
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

/*Listウィンドウ生成*/
- (void)createListWindow:(NSString *)category {
    MEGamePartsListWindowController *w = [[MEGamePartsListWindowController alloc]
            initWithWindowNibName:@"MEGamePartsListWindowController"
                         category:category
    ];
    [w.window makeKeyAndOrderFront:nil];
    [w.window setTitle:category];
    [self.gamePartsListWindowControllers addObject:w];
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
    [w.window setTitle:[filePath absoluteString]];
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
                selectedGameParts:[[self frontGamePartsListWindowController] selectedGameParts]
    ];
    w.onSetToToolWindow = [^(MEMatrix *_maxM, CGFloat _x, CGFloat _y, CGFloat _t, MEMatrix *cursor) {
        [self.gameMapToolsWindowController changedMapWindow:_maxM
                                                          x:_x
                                                          y:_y
                                                          t:_t
                                                     cursor:cursor];
    } copy];
    [w.window makeKeyAndOrderFront:nil];
//    [w.window setTitle:[filePath absoluteString]];
    [self.mapWindowControllers addObject:w];
}

/*編集関係の復元*/
- (void)restoreGamePartsListWindows:(NSMutableArray *)gamePartsArray tileSheets:(NSMutableArray *)tileSheets {
    //タイルウィンドウの復元
    [self.tileWindowControllers removeAllObjects];
    NSLog(@"unko0");
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

    NSLog(@"unko1");

    //リストウィンドウの復元
    [self.gamePartsListWindowControllers removeAllObjects];
    for (NSString *categoryName in [MECategory existCategories]) {
        MEGamePartsListWindowController *w = [[MEGamePartsListWindowController alloc]
                initWithWindowNibName:@"MEGamePartsListWindowController"
                             category:categoryName];
        [w.window setTitle:categoryName];
        [w.window makeKeyAndOrderFront:nil];

        for (NSDictionary *gamePartsDict in gamePartsArray) {
            MEGameParts *gameParts = gamePartsDict[@"game_parts"];
            /*
            if (![w.gamePartsViewController hasCategory:gameParts]) {
                continue;
            }
            */
            BOOL included = NO;
            for (NSString *category in gameParts.categories) {
                if ([category isEqualToString:categoryName]) {
                    included = YES;
                }
            }
            if (included) {
//                [w.gamePartsViewController.gamePartsArray addObject:gamePartsDict];
                [w.gamePartsViewController addGameParts:gameParts];
            }
        }
        w.gamePartsViewController.gamePartsArray =
                w.gamePartsViewController.gamePartsArray;
        [self.gamePartsListWindowControllers addObject:w];
    }

    NSLog(@"unko2");
}


//マップの復元
- (void)restoreMapWindow:(NSMutableArray *)gamePartsArray
              tileSheets:(NSMutableArray *)tileSheets
                 mapInfo:(NSMutableDictionary *)mapInfo
                filePath:(NSURL *)filePath {
    __block MEMainMenu *blockself = self;
    [self restoreGamePartsListWindows:gamePartsArray
                           tileSheets:tileSheets];
    
    NSLog(@"unko3");
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
                selectedGameParts:[[self frontGamePartsListWindowController] selectedGameParts]
    ];
    {
        NSDictionary *dict = mapInfo[@"allyStartPoint"];
        MEMatrix *mat = [[MEMatrix alloc] initWithX:[dict[@"x"] integerValue] Y:[dict[@"y"] integerValue] Z:[dict[@"z"] integerValue]];
        w.allyStartPoint2 = mat;
    }
    for(NSDictionary *dict in mapInfo[@"enemyStartPoints"]){
        MEMatrix *mat = [[MEMatrix alloc] initWithX:[dict[@"x"] integerValue] Y:[dict[@"y"] integerValue] Z:[dict[@"z"] integerValue]];
        [w.enemyStartPoints2 addObject:mat];
    }
    [w showFlags];
    w.category = mapInfo[@"category"];
    NSLog(@"unko4");
    w.onSetToToolWindow = [^(MEMatrix *_maxM, CGFloat _x, CGFloat _y, CGFloat _t, MEMatrix *cursor) {
        [blockself.gameMapToolsWindowController changedMapWindow:_maxM
                                                               x:_x
                                                               y:_y
                                                               t:_t
                                                          cursor:cursor];
    } copy];
    NSLog(@"unko5");
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
        /* タイルウィンドウを表示 */
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
        gamePartsListWindowControllers:self.gamePartsListWindowControllers
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
              gamePartsListWindowControllers:self.gamePartsListWindowControllers];
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

/*GamePartsListをjsonとしてexportする*/
- (IBAction)exportGamePartsListWindow:(id)sender {
    /*Saveダイアログを表示*/
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"parts", nil];
    [savePanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [savePanel runModal];

    if (pressedButton == NSOKButton) {
        NSURL *filePath = [savePanel URL];
        NSLog(@"file saved %@", filePath);
        /*jsonシリアライズして保存*/
        [MEEditSet saveGamePartsListJsonWithPath:filePath
                  gamePartsListWindowControllers:self.gamePartsListWindowControllers];
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


- (IBAction)syncToGameParts:(id)menuItem {
    /*
    MEGameMapWindowController *front = [self frontGameMapWindowController];
    if (!front) {
        return;
    }

    for (int x = 0; x < front.maxM.x; x++) {
        for (int y = 0; y < front.maxM.y; y++) {
            for (int z = 0; z < front.maxM.z; z++) {
                MEGameParts *cube = [front.jungleJym objectForKey:[front makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                                     Y:y
                                                                                                                     Z:z]]];

                if (!cube) {
                    continue;
                }

                MEGameParts *cube2 = [self.gamePartsListWindowController searchItemWithName:cube.name];
                if (!cube2) {
                    NSLog(@"name:%@ is nil. skip.", cube.name);
                    continue;

                }
                [front.jungleJym setObject:cube2 forKey:[front makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                           Y:y
                                                                                                           Z:z]]];
            }
        }
    }
    [front syncToGameParts];
    */
}


/*JSONからゲームマップウィンドウを開く*/
- (void)openGameMapWindowFromJson_:(NSArray *)gamePartsArray {
    __block MEMainMenu *blockself = self;
    /*Openダイアログを表示*/
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"json",@"map", nil];
    [openPanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [openPanel runModal];

    // NSLog(@"id:%@", self.gamePartsEditWindowController);
    if (pressedButton == NSOKButton) {
        NSURL *filePath = [openPanel URL];
        NSLog(@"file opened %@", filePath);
        [MEEditSet loadMapFromJson:filePath
                    gamePartsArray:gamePartsArray
                          complete:^(
                NSMutableDictionary *mapInfo

        ) {
            [blockself restoreMapWindow:gamePartsArray
                             tileSheets:nil
                                mapInfo:mapInfo
                               filePath:filePath
            ];
        }];
    }
}

/*ゲームパーツとマップ情報をロードし、ゲームマップウィンドウを開く*/
- (IBAction)openGameMapWindowFromJson:(id)sender {
    __block MEMainMenu *blockself = self;
    /*Openダイアログを表示*/
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"json", nil];
    [openPanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [openPanel runModal];

    // NSLog(@"id:%@", self.gamePartsEditWindowController);
    if (pressedButton == NSOKButton) {
        NSURL *filePath = [openPanel URL];
        NSLog(@"file opened %@", filePath);
        //ゲームパーツをロード
        NSArray *gamePartsArray =
                [MEEditSet gamePartsFromJson:filePath];
        [self openGameMapWindowFromJson_:gamePartsArray];
    }
}
@end
