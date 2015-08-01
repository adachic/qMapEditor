//
// Created by Akinori ADACHI on 2014/06/13.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MEGamePartsListWindowController;
@class MEGameMapWindowController;


@interface MEEditSet : NSObject

+ (void)saveGamePartsListWithPath:(NSURL *)filePath
            tileWindowControllers:(NSArray *)tileWindowControllers
   gamePartsListWindowControllers:(NSArray *)gamePartsListWindowControllers;

+ (void)loadEditSetFromFile:(NSURL *)filePath
                   complete:(void (^)(
                           NSMutableArray *gamePartsArray,
                           NSMutableArray *tileSheets
                   ))completed;

+ (void)saveGameMapWithPath:(NSURL *)filePath
         tileWindowControllers:(NSArray *)tileWindowControllers
gamePartsListWindowControllers:(NSArray *)gamePartsListWindowControllers
       gameMapWindowController:(MEGameMapWindowController *)gameMapWindowController;

+ (void)loadMapFromFile:filePath
               complete:(void (^)(
                       NSMutableArray *gamePartsArray,
                       NSMutableArray *tileSheets,
                       NSMutableDictionary *mapInfo
               ))completed;

+ (void)saveMapJsonWithPath:(NSURL *)filePath
        mapWindowController:(MEGameMapWindowController *)mapWindowController;
@end