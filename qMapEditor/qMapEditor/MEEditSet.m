//
// Created by Akinori ADACHI on 2014/06/13.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import "MEEditSet.h"
#import "MEGamePartsListWindowController.h"
#import "METileWindowController.h"
#import "MEGameMapWindowController.h"
#import "MEMatrix.h"
#import "MEGameParts.h"


@implementation MEEditSet

/*
* gameParts情報を保存
 */
+ (void)saveGamePartsListWithPath:(NSURL *)filePath
            tileWindowControllers:(NSArray *)tileWindowControllers
   gamePartsListWindowControllers:(NSArray *)gamePartsListWindowControllers {
    NSMutableArray *tileSheets = [NSMutableArray array];
    for (METileWindowController *twc in tileWindowControllers) {
        if (!twc.readyToPickUp) {
            continue;
        }
        NSArray *values = @[[NSNumber numberWithInteger:twc.widthCellsNum.intValue],
                [NSNumber numberWithInteger:twc.heightCellsNum.intValue],
                twc.imageURL];
        NSArray *key = @[@"widthNum", @"heightNum", @"filePath"];
        NSDictionary *tileSheet = [NSDictionary dictionaryWithObjects:values forKeys:key];
        [tileSheets addObject:tileSheet];
    }
    {
        //すべてのゲームパーツを収集
        NSMutableArray *allGameParts = [@[] mutableCopy];
        for (MEGamePartsListWindowController *w in gamePartsListWindowControllers) {
            [allGameParts addObjectsFromArray:w.gamePartsViewController.gamePartsArray];
        }
        NSArray *values = @[allGameParts, tileSheets];
        NSArray *keys = [NSArray arrayWithObjects:@"gamePartsArray",
                                                  @"tileSheets", nil];
        NSDictionary *saveDict = [NSDictionary dictionaryWithObjects:values
                                                             forKeys:keys];
        /*
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        path = [path stringByAppendingPathComponent:@"teste.wrapit"];
        */
        if (![NSKeyedArchiver archiveRootObject:saveDict toFile:[filePath path]]) {
            NSAssert(false, @"file save failed.");
        }
    }
}

+ (void)loadEditSetFromFile:(NSURL *)filePath
                   complete:(void (^)(NSMutableArray *gamePartsArray, NSMutableArray *tileSheets))completed {

    /*
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:@"teste.wrapit"];
    */
    NSDictionary *loadDict = [NSKeyedUnarchiver unarchiveObjectWithFile:[filePath path]];
    NSMutableArray *gamePartsArray = [loadDict objectForKey:@"gamePartsArray"];
    NSMutableArray *tileSheets = [loadDict objectForKey:@"tileSheets"];
    completed(gamePartsArray, tileSheets);
}

+ (void)   saveGameMapWithPath:(NSURL *)filePath
         tileWindowControllers:(NSArray *)tileWindowControllers
gamePartsListWindowControllers:(NSArray *)gamePartsListWindowControllers
       gameMapWindowController:(MEGameMapWindowController *)gameMapWindowController {
    NSMutableArray *tileSheets = [NSMutableArray array];
    for (METileWindowController *twc in tileWindowControllers) {
        if (!twc.readyToPickUp) {
            continue;
        }
        NSArray *values = @[[NSNumber numberWithInteger:twc.widthCellsNum.intValue],
                [NSNumber numberWithInteger:twc.heightCellsNum.intValue],
                twc.imageURL];
        NSArray *key = @[@"widthNum", @"heightNum", @"filePath"];
        NSDictionary *tileSheet = [NSDictionary dictionaryWithObjects:values forKeys:key];
        [tileSheets addObject:tileSheet];
    }

    NSDictionary *mapInfo;
    {
        NSArray *values = @[
                gameMapWindowController.jungleJym,
                [NSNumber numberWithFloat:(float) gameMapWindowController.aspectX],
                [NSNumber numberWithFloat:(float) gameMapWindowController.aspectY],
                [NSNumber numberWithFloat:(float) gameMapWindowController.aspectT],
                [NSNumber numberWithInteger:gameMapWindowController.maxM.x],
                [NSNumber numberWithInteger:gameMapWindowController.maxM.y],
                [NSNumber numberWithInteger:gameMapWindowController.maxM.z]
        ];
        NSArray *key = @[@"jungleGym",
                @"aspectX",
                @"aspectY",
                @"aspectT",
                @"maxX",
                @"maxY",
                @"maxZ",
        ];
        mapInfo = [NSDictionary dictionaryWithObjects:values forKeys:key];
    }
    {
        //すべてのゲームパーツを収集
        NSMutableArray *allGameParts = [@[] mutableCopy];
        for (MEGamePartsListWindowController *w in gamePartsListWindowControllers) {
            [allGameParts addObjectsFromArray:w.gamePartsViewController.gamePartsArray];
        }
        NSArray *values = @[
                allGameParts,
                tileSheets,
                mapInfo
        ];
        NSArray *keys = @[@"gamePartsArray",
                @"tileSheets",
                @"mapInfo"];
        NSDictionary *saveDict = [NSDictionary dictionaryWithObjects:values
                                                             forKeys:keys];
        if (![NSKeyedArchiver archiveRootObject:saveDict toFile:[filePath path]]) {
            NSAssert(false, @"file save failed.");
        }
    }
}

/*
 * jsonを開く
 */
+ (void)loadMapFromJson:(NSURL *)filePath
         gamePartsArray:(NSArray *)gamePartsArray
               complete:(void (^)(
                       NSMutableDictionary *mapInfo
               ))completed {
    /*
    NSDictionary *loadDict = [NSKeyedUnarchiver unarchiveObjectWithFile:[filePath path]];
    NSMutableArray *gamePartsArray = [loadDict objectForKey:@"gamePartsArray"];
    NSMutableArray *tileSheets = [loadDict objectForKey:@"tileSheets"];
    NSMutableDictionary *mapInfo = [loadDict objectForKey:@"mapInfo"];
    */

    NSData *data = [NSData dataWithContentsOfURL:filePath];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", obj);

    NSDictionary *rootDict = obj;
    NSMutableDictionary *mapDict = [@{} mutableCopy];
    mapDict[@"maxX"] = rootDict[@"maxX"];
    mapDict[@"maxY"] = rootDict[@"maxY"];
    mapDict[@"maxZ"] = rootDict[@"maxZ"];
    mapDict[@"aspectX"] = rootDict[@"aspectX"];
    mapDict[@"aspectY"] = rootDict[@"aspectY"];
    mapDict[@"aspectT"] = rootDict[@"aspectT"];

    mapDict[@"allyStartPoint"] = rootDict[@"allyStartPoint"];
    mapDict[@"enemyStartPoints"] = rootDict[@"enemyStartPoints"];
    mapDict[@"category"] = rootDict[@"category"];

    mapDict[@"jungleGym"] = [@{} mutableCopy];
    {
        for (NSDictionary *cubeDict in rootDict[@"jungleGym"]) {
            for (NSDictionary *partsDict  in gamePartsArray) {
                NSString *idStr = partsDict[@"name"];
                NSString *cubeIdStr = cubeDict[@"id"];
                if ([idStr isEqualToString:cubeIdStr]) {
                    int idx = [cubeDict[@"z"] intValue] * 10000 +
                            [cubeDict[@"y"] intValue] * 100 +
                            [cubeDict[@"x"] intValue];
                    NSString *idxStr = [NSString stringWithFormat:@"%d", idx];
                    mapDict[@"jungleGym"][idxStr] = partsDict[@"game_parts"];
                }
            }
        }
    }
    completed(mapDict);
};

/**
 * mdatを開く
 */
+ (void)loadMapFromFile:(NSURL *)filePath
               complete:(void (^)(
                       NSMutableArray *gamePartsArray,
                       NSMutableArray *tileSheets,
                       NSMutableDictionary *mapInfo
               ))completed {
    NSDictionary *loadDict = [NSKeyedUnarchiver unarchiveObjectWithFile:[filePath path]];
    NSMutableArray *gamePartsArray = [loadDict objectForKey:@"gamePartsArray"];
    NSMutableArray *tileSheets = [loadDict objectForKey:@"tileSheets"];
    NSMutableDictionary *mapInfo = [loadDict objectForKey:@"mapInfo"];
    completed(gamePartsArray, tileSheets, mapInfo);
};

/*
* PartsListをjsonエクスポートする。
 */
+ (void)saveGamePartsListJsonWithPath:(NSURL *)filePath
       gamePartsListWindowControllers:(NSMutableArray *)gamePartsListWindowControllers {

    NSMutableDictionary *partsData = [NSMutableDictionary dictionary];
//    NSMutableArray *gamePartsArray = [NSMutableArray array];
    NSMutableSet *doubleCheck = [NSMutableSet set];

    for (MEGamePartsListWindowController *gamePartsListWC in gamePartsListWindowControllers) {
        for (NSDictionary *gameP in gamePartsListWC.gamePartsViewController.gamePartsArray) {
            MEGameParts *cube = gameP[@"game_parts"];
            if ([doubleCheck containsObject:cube]) {
                NSAssert(false, @"doubleCheck fault.");
                continue;
            }
            [doubleCheck addObject:cube];

            NSMutableDictionary *partsDict = [NSMutableDictionary dictionary];
            [partsDict setObject:cube.name forKey:@"id"];
            NSMutableArray *tiles = [NSMutableArray array];
            for (METile *tile in cube.tiles) {
                NSMutableDictionary *tileDict = [NSMutableDictionary dictionary];
                [tileDict setObject:[tile.tileFilePath lastPathComponent] forKey:@"tile"];
                [tileDict setObject:[NSNumber numberWithFloat:(float) tile.tileRect.origin.x] forKey:@"x"];
                [tileDict setObject:[NSNumber numberWithFloat:(float) tile.tileRect.origin.y] forKey:@"y"];
                [tileDict setObject:[NSNumber numberWithFloat:(float) tile.tileRect.size.width] forKey:@"w"];
                [tileDict setObject:[NSNumber numberWithFloat:(float) tile.tileRect.size.height] forKey:@"h"];
                [tiles addObject:tileDict];
            }
            [partsDict setObject:tiles forKey:@"tiles"];
            [partsDict setObject:[NSNumber numberWithBool:cube.walkable] forKey:@"walkable"];
            [partsDict setObject:[NSNumber numberWithInt:cube.watertype] forKey:@"waterType"];
            [partsDict setObject:[NSNumber numberWithInt:cube.snow] forKey:@"snow"];
            [partsDict setObject:[NSNumber numberWithBool:cube.half] forKey:@"harf"];
            [partsDict setObject:[NSNumber numberWithInt:cube.rezoTypeRect] forKey:@"rezo"];

            [partsDict setObject:cube.harfIdName ?: @"" forKey:@"harfId"];

            [partsDict setObject:cube.categories forKey:@"category"];
            [partsDict setObject:@(cube.getCategoryInt) forKey:@"category"];

            [partsDict setObject:@(cube.pavementType) forKey:@"pavementType"];
            if (cube.macroTypes) {
                [partsDict setObject:cube.macroTypes forKey:@"macroTypes"];
            }
            partsData[cube.name] = partsDict;
//            [gamePartsArray addObject:partsDict];
        }
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:partsData options:0 error:&error];
    NSLog(@"returned error1: %@", [error localizedDescription]);
    [jsonData writeToFile:[filePath path] options:NSDataWritingAtomic error:&error];
    NSLog(@"returned error2: %@", [error localizedDescription]);
}

/**
 * PartsListをjsonインポートする
 */
+ (NSMutableArray *)gamePartsFromJson:(NSURL *)filePath {
    NSData *data = [NSData dataWithContentsOfURL:filePath];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", obj);

    NSMutableArray *partsArray = [@[] mutableCopy];
    {
        NSDictionary *rootDict = obj;
        for (id key in rootDict) {
            NSDictionary *partRoot = rootDict[key];
            NSMutableArray *tiles = [@[] mutableCopy];
            {
                NSArray *parttiles = partRoot[@"tiles"];
                for (NSDictionary *tileDict in parttiles) {
                    CGRect rect = CGRectMake([tileDict[@"x"] intValue],
                            [tileDict[@"y"] intValue],
                            [tileDict[@"w"] intValue],
                            [tileDict[@"h"] intValue]);
                    NSMutableString *fpath = [@"file://" mutableCopy];
                    [fpath appendString:NSHomeDirectory()];
                    [fpath appendString:@"/Documents/qMapEditor/assets/tiles/"];
                    [fpath appendString:tileDict[@"tile"]];
                    NSURL *tileFilePath = [NSURL URLWithString:fpath];
//                    NSURL *tileFilePath = [NSURL fileURLWithPath:tileDict[@"tile"]];
                    METile *tile = [[METile alloc] initWithURL:tileFilePath rect:rect];
                    [tiles addObject:tile];
                }
            }
            NSMutableArray *categories = [@[] mutableCopy];
            {
                [categories addObject:[MEGameParts getCategory:[partRoot[@"category"] intValue]]];
            }
            /*
            NSMutableArray *macroTypes = [@[] mutableCopy];
            {
                NSArray *macros = partRoot[@"macroTypes"];
                for(NSNumber *num in macros){
                    [macroTypes addObject:num];
                }
            }
            */
            MEGameParts *cube = [[MEGameParts alloc] initWithTiles:tiles
                                                          walkable:[partRoot[@"walkable"] boolValue]
                                                         waterType:(WaterType) [partRoot[@"waterType"] intValue]
                                                          duration:0
                                                              half:[partRoot[@"harf"] boolValue]
                                                          rezoType:(RezoTypeRect) [partRoot[@"rezo"] intValue]
                                                        categories:categories
                                                      pavementType:(PavementType) [partRoot[@"pavementType"] intValue]
                                                        macroTypes:partRoot[@"macroTypes"]
                                                              snow:[partRoot[@"snow"] boolValue]
                                                        harfIdName:partRoot[@"harfId"]
                                                      customEvents:@{}];
            cube.name = partRoot[@"id"];
            [cube createSampleImageForJsonLoading];

            NSMutableDictionary *dictCube = [@{} mutableCopy];
            dictCube[@"game_parts"] = cube;
            dictCube[@"name"] = cube.name;
            [partsArray addObject:dictCube];
        }
    }
    return partsArray;
}

/*
* Mapをjsonエクスポートする。
 */
+ (void)saveMapJsonWithPath:(NSURL *)filePath
        mapWindowController:(MEGameMapWindowController *)mapWindowController {

    NSMutableDictionary *mapData = [NSMutableDictionary dictionary];
    NSMutableArray *gamePartsArray = [NSMutableArray array];
    NSMutableSet *doubleCheck = [NSMutableSet set];
    for (int x = 0; x < mapWindowController.maxM.x; x++) {
        for (int y = 0; y < mapWindowController.maxM.y; y++) {
            for (int z = 0; z < mapWindowController.maxM.z; z++) {
                MEGameParts *cube = [mapWindowController.jungleJym objectForKey:[mapWindowController makeTagWithMatrix:[[MEMatrix alloc]
                        initWithX:x Y:y Z:z]]];
                if (!cube) {
                    continue;
                }
                if ([doubleCheck containsObject:cube.name]) {
                    continue;
                }
                [doubleCheck addObject:cube.name];
                NSMutableDictionary *partsDict = [NSMutableDictionary dictionary];
                [partsDict setObject:cube.name forKey:@"id"];
                NSMutableArray *tiles = [NSMutableArray array];
                for (METile *tile in cube.tiles) {
                    NSMutableDictionary *tileDict = [NSMutableDictionary dictionary];
                    [tileDict setObject:[tile.tileFilePath lastPathComponent] forKey:@"tile"];
                    [tileDict setObject:[NSNumber numberWithFloat:(float) tile.tileRect.origin.x] forKey:@"x"];
                    [tileDict setObject:[NSNumber numberWithFloat:(float) tile.tileRect.origin.y] forKey:@"y"];
                    [tileDict setObject:[NSNumber numberWithFloat:(float) tile.tileRect.size.width] forKey:@"w"];
                    [tileDict setObject:[NSNumber numberWithFloat:(float) tile.tileRect.size.height] forKey:@"h"];
                    [tiles addObject:tileDict];
                }
                [partsDict setObject:tiles forKey:@"tiles"];
                [partsDict setObject:[NSNumber numberWithBool:cube.walkable] forKey:@"walkable"];
                [partsDict setObject:[NSNumber numberWithInt:cube.watertype] forKey:@"waterType"];
                [partsDict setObject:[NSNumber numberWithBool:cube.half] forKey:@"harf"];
                [partsDict setObject:[NSNumber numberWithInt:cube.rezoTypeRect] forKey:@"rezo"];
                [gamePartsArray addObject:partsDict];
            }
        }
    }
    [mapData setObject:gamePartsArray forKey:@"gameParts"];

    [mapData setObject:[NSNumber numberWithFloat:(float) mapWindowController.aspectX] forKey:@"aspectX"];
    [mapData setObject:[NSNumber numberWithFloat:(float) mapWindowController.aspectY] forKey:@"aspectY"];
    [mapData setObject:[NSNumber numberWithFloat:(float) mapWindowController.aspectT] forKey:@"aspectT"];
    [mapData setObject:[NSNumber numberWithInteger:mapWindowController.maxM.x] forKey:@"maxX"];
    [mapData setObject:[NSNumber numberWithInteger:mapWindowController.maxM.y] forKey:@"maxY"];
    [mapData setObject:[NSNumber numberWithInteger:mapWindowController.maxM.z] forKey:@"maxZ"];

    if(mapWindowController.allyStartPoint2){
        NSMutableDictionary *dict = [@{} mutableCopy];
        dict[@"x"] = @(mapWindowController.allyStartPoint2.x);
        dict[@"y"] = @(mapWindowController.allyStartPoint2.y);
        dict[@"z"] = @(mapWindowController.allyStartPoint2.z);
        [mapData setObject:dict forKey:@"allyStartPoint"];
    }
    if(mapWindowController.enemyStartPoints2){
        NSMutableArray *arr = [@[] mutableCopy];
        for(MEMatrix *mat in mapWindowController.enemyStartPoints2){
            NSMutableDictionary *dict = [@{} mutableCopy];
            dict[@"x"] = @(mat.x);
            dict[@"y"] = @(mat.y);
            dict[@"z"] = @(mat.z);
            [arr addObject:dict];
        }
        [mapData setObject:arr forKey:@"enemyStartPoints"];
    }
    if(mapWindowController.category){
        [mapData setObject:mapWindowController.category forKey:@"category"];
    }

    NSMutableArray *cubes = [NSMutableArray array];
    for (int x = 0; x < mapWindowController.maxM.x; x++) {
        for (int y = 0; y < mapWindowController.maxM.y; y++) {
            for (int z = 0; z < mapWindowController.maxM.z; z++) {
                MEGameParts *cube = [mapWindowController.jungleJym objectForKey:[mapWindowController makeTagWithMatrix:[[MEMatrix alloc]
                        initWithX:x Y:y Z:z]]];
                if (!cube) {
                    continue;
                }
                NSMutableDictionary *cubeDict = [NSMutableDictionary dictionary];
                [cubeDict setObject:cube.name forKey:@"id"];
                [cubeDict setObject:[NSNumber numberWithInteger:x] forKey:@"x"];
                [cubeDict setObject:[NSNumber numberWithInteger:y] forKey:@"y"];
                [cubeDict setObject:[NSNumber numberWithInteger:z] forKey:@"z"];
                [cubes addObject:cubeDict];
            }
        }
    }
    [mapData setObject:cubes forKey:@"jungleGym"];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    NSLog(@"returned error1: %@", [error localizedDescription]);
    [jsonData writeToFile:[filePath path] options:NSDataWritingAtomic error:&error];
    NSLog(@"returned error2: %@", [error localizedDescription]);
}


@end