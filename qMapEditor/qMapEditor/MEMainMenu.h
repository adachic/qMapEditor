//
//  MEMainMenu.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MEMainMenu : NSMenu

@property IBOutlet NSMenuItem *itemCreateGameParts;

- (id)init;
- (IBAction)createGameParts:(id)sender;
- (BOOL)validateMenuItem:(id )menuItem;
@end
