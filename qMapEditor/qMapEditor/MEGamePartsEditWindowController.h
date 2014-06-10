//
//  MEGamePartsEditWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MEGameParts;

@interface MEGamePartsEditWindowController : NSWindowController

- (void)setTopViewWithImage:(NSImage *)tile;
- (IBAction)pushedAddGameParts:(id)sender;
- (IBAction)pushedDeleteGameParts:(id)sender;
- (IBAction)pushedModifyGameParts:(id)sender;

- (void)hoge:(id)obj;
typedef void (^_onRegistGameParts)(MEGameParts *gameParts);
typedef void (^_onUpdateGameParts)(MEGameParts *gameParts);
typedef void (^_onDeleteGameParts)();

@property (copy) _onRegistGameParts onRegistGameParts;
@property (copy) _onUpdateGameParts onUpdateGameParts;
@property (copy) _onDeleteGameParts onDeleteGameParts;

@property IBOutlet NSImageView *topImageView;


@end
