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
@class MECategoryTableView;

@interface MEGamePartsEditWindowController : NSWindowController<NSTableViewDataSource, NSTableViewDelegate>
{
    MEGameParts *buildingGameParts;
}

- (void)setViewWithGameParts:(MEGameParts *)gameParts;
- (void)setViewWithTile:(METile *)tile;
- (void)tableViewReload;

- (IBAction)pushedAddGameParts:(id)sender;
- (IBAction)pushedDeleteGameParts:(id)sender;
- (IBAction)pushedModifyGameParts:(id)sender;

- (IBAction)pushedSwitchAnimMode:(id)sender;
- (IBAction)pushedClearAnim:(id)sender;
- (IBAction)pushedRadioCell:(id)sender;

typedef void (^_onRegistGameParts)(MEGameParts *gameParts);
typedef void (^_onUpdateGameParts)(MEGameParts *gameParts);
typedef void (^_onDeleteGameParts)();
typedef void (^_onSelectedGameParts)(MEGameParts *gameParts);

@property (copy) _onRegistGameParts onRegistGameParts;
@property (copy) _onUpdateGameParts onUpdateGameParts;
@property (copy) _onDeleteGameParts onDeleteGameParts;
@property (copy) _onSelectedGameParts onSelectedGameParts;

@property IBOutlet NSImageView *topImageView;
@property IBOutlet NSMatrix *waterRadioGroup;
@property IBOutlet NSButton *walkable;
@property IBOutlet NSButton *half;
@property IBOutlet NSButton *rezoType;
@property IBOutlet MECategoryTableView *categoryTableView;

@property IBOutlet MEAnimationBaseView *animationViewBase;
@property IBOutlet NSButton *addAnimationModeButton;
@property IBOutlet NSButton *clearAnimationButton;

@property IBOutlet NSTextField *modeLabel;

@property IBOutlet NSSegmentedControl *pavementControl;
@property IBOutlet NSButton *macroRoad;
@property IBOutlet NSButton *macroRaugh;
@property IBOutlet NSButton *macroWall;
@property IBOutlet NSButton *macroCantEnter;
@property IBOutlet NSButton *macroOther;

@property IBOutlet NSButton *snowButton;

@property IBOutlet NSTextField *harfIdTextField;

@end
