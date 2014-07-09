//
//  MEGamePartsEditWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MEGameParts;
@class METile;
@class MEAnimationBaseView;

@interface MEGamePartsEditWindowController : NSWindowController
{
    MEGameParts *buildingGameParts;
}

- (void)setViewWithGameParts:(MEGameParts *)gameParts;
- (void)setViewWithTile:(METile *)tile;

- (IBAction)pushedAddGameParts:(id)sender;
- (IBAction)pushedDeleteGameParts:(id)sender;
- (IBAction)pushedModifyGameParts:(id)sender;

- (IBAction)pushedSwitchAnimMode:(id)sender;
- (IBAction)pushedClearAnim:(id)sender;

- (void)hoge:(id)obj;

typedef void (^_onRegistGameParts)(MEGameParts *gameParts);
typedef void (^_onUpdateGameParts)(MEGameParts *gameParts);
typedef void (^_onDeleteGameParts)();
typedef void (^_onSelectedGameParts)(MEGameParts *gameParts);

@property (copy) _onRegistGameParts onRegistGameParts;
@property (copy) _onUpdateGameParts onUpdateGameParts;
@property (copy) _onDeleteGameParts onDeleteGameParts;
@property (copy) _onSelectedGameParts onSelectedGameParts;

@property IBOutlet NSImageView *topImageView;
@property IBOutlet NSTextField *durationPerFlame;

@property IBOutlet NSButton *walkable;
@property IBOutlet NSButton *half;
@property IBOutlet NSButton *animation;

@property IBOutlet MEAnimationBaseView *animationViewBase;
@property IBOutlet NSButton *addAnimationModeButton;
@property IBOutlet NSButton *clearAnimationButton;

@property IBOutlet NSTextField *modeLabel;

@end
