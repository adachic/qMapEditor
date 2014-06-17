//
//  MEMainMenu.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MEGamePartsEditWindowController.h"
#import "MEGamePartsListWindowController.h"
#import "MEGameMapToolsWindowController.h"
#import "MEGameParts.h"

@interface MEMainMenu : NSMenu


@property IBOutlet NSMenuItem *itemCreateGameParts;

@property IBOutlet  MEGamePartsEditWindowController *gamePartsEditWindowController;
@property IBOutlet  MEGamePartsListWindowController *gamePartsListWindowController;
@property IBOutlet  MEGameMapToolsWindowController *gameMapToolsWindowController;

@property NSMutableArray *tileWindowControllers;
@property NSMutableArray *mapWindowControllers;

- (id)initWithCoder:(NSCoder *)aDecoder ;
- (IBAction)showGameParts:(id)sender;
- (BOOL)validateMenuItem:(id )menuItem;
- (IBAction)openTileFile:(id)sender;
-(void)createTileWindow:(NSURL*)filePath;
@end
