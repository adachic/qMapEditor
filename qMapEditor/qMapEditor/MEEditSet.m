//
// Created by Akinori ADACHI on 2014/06/13.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import "MEEditSet.h"
#import "MEGamePartsListWindowController.h"
#import "METileWindowController.h"


@implementation MEEditSet

+ (void)saveEditSetFileWithPath:(NSURL *)filePath
          tileWindowControllers:(NSArray *)tileWindowControllers
  gamePartsListWindowController:(MEGamePartsListWindowController *)gamePartsListWindowController {
    NSMutableArray *tileSheets = [NSMutableArray array];
    for (METileWindowController *twc in tileWindowControllers) {
        if(!twc.readyToPickUp){
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
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        path = [path stringByAppendingPathComponent:@"teste.wrapit"];
        if (![NSKeyedArchiver archiveRootObject:saveDict toFile:path]) {
            NSAssert(false, @"file save failed.");
        }
    }
}

+ (void)loadEditSetFromFile:(NSURL *)filePath
                   complete:(void (^)(NSMutableArray *gamePartsArray, NSMutableArray *tileSheets))completed {

    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:@"teste.wrapit"];
    NSDictionary *loadDict = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

    NSMutableArray *gamePartsArray = [loadDict objectForKey:@"gamePartsArray"];
    NSMutableArray *tileSheets = [loadDict objectForKey:@"tileSheets"];

    completed(gamePartsArray, tileSheets);
}

@end