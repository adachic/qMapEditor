//
//  MEGameMapToolsWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MEMatrix;

@interface MEGameMapToolsWindowController : NSWindowController <NSWindowDelegate>

typedef void (^_onSetToMapWindow)(MEMatrix *_maxM, CGFloat _x, CGFloat _y, CGFloat _t);

typedef void (^_onMaxXModifyToMapWindow)(BOOL shouldUp);

typedef void (^_onMaxYModifyToMapWindow)(BOOL shouldUp);

typedef void (^_onMaxZModifyToMapWindow)(BOOL shouldUp);

typedef void (^_onCursorZModifyToMapWindow)(BOOL shouldUp);

typedef void (^_onSwitchPenToMapWindow)();

typedef void (^_onSwitchEraserToMapWindow)();

typedef void (^_onFillLayerToMapWindow)();

typedef void (^_onClearLayerToMapWindow)();

@property(strong) _onSetToMapWindow onSetToMapWindow;
@property(strong) _onMaxXModifyToMapWindow onMaxXModifyToMapWindow;
@property(strong) _onMaxYModifyToMapWindow onMaxYModifyToMapWindow;
@property(strong) _onMaxZModifyToMapWindow onMaxZModifyToMapWindow;
@property(strong) _onCursorZModifyToMapWindow onCursorZModifyToMapWindow;
@property(strong) _onSwitchPenToMapWindow onSwitchPenToMapWindow;
@property(strong) _onSwitchEraserToMapWindow onSwitchEraserToMapWindow;
@property(strong) _onFillLayerToMapWindow onFillLayerToMapWindow;
@property(strong) _onClearLayerToMapWindow onClearLayerToMapWindow;

@property IBOutlet NSTextField *tfAspectX;
@property IBOutlet NSTextField *tfAspectY;
@property IBOutlet NSTextField *tfAspectT;
@property IBOutlet NSTextField *tfParhaps;

@property IBOutlet NSTextField *tfMaxX;
@property IBOutlet NSTextField *tfMaxY;
@property IBOutlet NSTextField *tfMaxZ;

@property IBOutlet NSButton *buttonAspectFix;
@property IBOutlet NSView *sampleTileView;

@property CGFloat aspectX;
@property CGFloat aspectY;
@property CGFloat aspectT;
@property MEMatrix *maxM;


- (IBAction)clickedAspectFix:(id)sender;

- (void)showParhapsSize:(CGFloat)x y:(CGFloat)y t:(CGFloat)t;

- (void)changedMapWindow:(MEMatrix *)maxM x:(CGFloat)x y:(CGFloat)y t:(CGFloat)t;


- (IBAction)clickdMaxXUpper:(id)sender;

- (IBAction)clickdMaxXDowner:(id)sender;

- (IBAction)clickdMaxYUpper:(id)sender;

- (IBAction)clickdMaxYDowner:(id)sender;

- (IBAction)clickdMaxZUpper:(id)sender;

- (IBAction)clickdMaxZDowner:(id)sender;

- (IBAction)clickdUpButton:(id)sender;

- (IBAction)clickdDownButton:(id)sender;

- (IBAction)clickdPenButton:(id)sender;

- (IBAction)clickdEraserButton:(id)sender;

- (IBAction)clickdFillLayerButton:(id)sender;

- (IBAction)clickdClearLayerButton:(id)sender;

@end
