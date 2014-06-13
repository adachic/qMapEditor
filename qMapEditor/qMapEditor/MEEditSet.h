//
// Created by Akinori ADACHI on 2014/06/13.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MEGamePartsListWindowController;


@interface MEEditSet : NSObject

+ (void)saveEditSetFileWithPath:(NSURL *)filePath
          tileWindowControllers:(NSArray *)tileWindowControllers
  gamePartsListWindowController:(MEGamePartsListWindowController*)gamePartsListWindowController;

+ (void)loadEditSetFromFile:(NSURL *)filePath
                   complete:(void (^)(NSMutableArray *gamePartsArray, NSMutableArray *tileSheets))completed;

@end