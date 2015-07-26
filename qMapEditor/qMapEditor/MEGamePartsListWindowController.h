//
//  MEMEGamePartsListWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MEGamePartsViewController.h"

@interface MEGamePartsListWindowController : NSWindowController

//@property MEGamePartsViewController *gamePartsViewController;
@property NSMutableArray *gamePartsViewControllers;

@property IBOutlet NSTabView	*tabView;
@property IBOutlet NSTextField *selectionField;

- (void)addGameParts:(MEGameParts *)gameParts;
- (void)updateGameParts:(MEGameParts *)gameParts;
- (void)deleteGameParts;
- (MEGameParts *)selectedGameParts;
- (MEGameParts *)searchItemWithName:(NSString*)name;

@end
