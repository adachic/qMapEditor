//
// Created by Akinori ADACHI on 2014/06/13.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import "MEEditSet.h"
#import "MEGamePartsListWindowController.h"
#import "METileWindowController.h"
#import "MEGameMapWindowController.h"
#import "MEMatrix.h"


@implementation MEEditSet

+ (void)saveGamePartsListWithPath:(NSURL *)filePath
            tileWindowControllers:(NSArray *)tileWindowControllers
    gamePartsListWindowController:(MEGamePartsListWindowController *)gamePartsListWindowController {
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
        NSArray *values = @[gamePartsListWindowController.gamePartsViewController.gamePartsArray, tileSheets];
        NSArray *keys = [NSArray arrayWithObjects:@"gamePartsArray",
                                                  @"tileSheets",
                                                  nil];
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
gamePartsListWindowController:(MEGamePartsListWindowController *)gamePartsListWindowController
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
        NSArray *values = @[
                gamePartsListWindowController.gamePartsViewController.gamePartsArray,
                tileSheets,
                mapInfo
        ];
        NSArray *keys = [NSArray arrayWithObjects:@"gamePartsArray",
                                                  @"tileSheets",
                                                  @"mapInfo",
                                                  nil];
        NSDictionary *saveDict = [NSDictionary dictionaryWithObjects:values
                                                             forKeys:keys];
        if (![NSKeyedArchiver archiveRootObject:saveDict toFile:[filePath path]]) {
            NSAssert(false, @"file save failed.");
        }
    }
}

+ (void)loadMapFromFile:filePath
               complete:(void (^)(
                       NSMutableArray *gamePartsArray,
                       NSMutableArray *tileSheets,
                       NSMutableDictionary *mapInfo
               ))completed
{
    NSDictionary *loadDict = [NSKeyedUnarchiver unarchiveObjectWithFile:[filePath path]];
    NSMutableArray *gamePartsArray = [loadDict objectForKey:@"gamePartsArray"];
    NSMutableArray *tileSheets = [loadDict objectForKey:@"tileSheets"];
    NSDictionary *mapInfo = [loadDict objectForKey:@"mapInfo"];
    completed(gamePartsArray, tileSheets, mapInfo);
};
@end