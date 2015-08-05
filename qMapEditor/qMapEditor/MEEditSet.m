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
        for(MEGamePartsListWindowController *w in gamePartsListWindowControllers){
            [allGameParts addObjectsFromArray:w.gamePartsViewController.gamePartsArray];
        }
        NSArray *values = @[allGameParts, tileSheets];
        NSArray *keys = [NSArray arrayWithObjects:@"gamePartsArray",
                                                  @"tileSheets",nil];
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

+ (void)saveGameMapWithPath:(NSURL *)filePath
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
        for(MEGamePartsListWindowController *w in gamePartsListWindowControllers){
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
* jsonエクスポートする。
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
                if ([doubleCheck containsObject:cube.name]){
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