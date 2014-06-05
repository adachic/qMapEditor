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

@interface MEMainMenu : NSMenu

@property IBOutlet NSMenuItem *itemCreateGameParts;
@property (retain) MEGamePartsEditWindowController *gamePartsEditWindowController;
@property (retain) MEGamePartsListWindowController *gamePartsListWindowController;


- (id)initWithCoder:(NSCoder *)aDecoder ;
- (IBAction)showGameParts:(id)sender;
- (BOOL)validateMenuItem:(id )menuItem;
@end
