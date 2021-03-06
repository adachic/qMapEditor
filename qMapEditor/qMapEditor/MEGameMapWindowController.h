//
//  MEGameMapWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MEMatrix;
@class MEGameParts;

@interface MEGameMapWindowController : NSWindowController <NSWindowDelegate>

typedef void (^_onSetToToolWindow)(MEMatrix *_maxM, CGFloat _x, CGFloat _y, CGFloat _t, MEMatrix *cursor);

@property(strong) _onSetToToolWindow onSetToToolWindow;
@property MEGameParts *selectedGameParts;

@property MEMatrix *maxM;
@property MEMatrix *currentCursor;

@property CGFloat aspectX;
@property CGFloat aspectY;
@property CGFloat aspectT;

@property BOOL shouldShowUpper;
@property BOOL shouldShowGriph;
@property BOOL shouldShowLines;

@property NSDictionary *allyStartPoint;
@property NSArray *enemyStartPoints;
@property NSNumber *category;

@property MEMatrix *allyStartPoint2;
@property NSMutableArray<MEMatrix *> *enemyStartPoints2;

@property NSMutableDictionary *jungleJym;
@property NSString *filePath;
@property NSMutableArray *workingEmptyCursors;
typedef enum EditMapMode {
    kEditMapModePenMode,
    kEditMapModeEraserMode,
    kEditMapModeAllyFlagMode,
    kEditMapModeEnemyFlagMode,
    kEditMapModeEraserEnemyFlagMode,
};

@property enum EditMapMode editMapMode;

- (id)initWithWindowNibName:(NSString *)windowNibName
                    fileURL:(NSURL *)url
                       maxM:(MEMatrix *)maxSize
                    aspectX:(CGFloat)x
                    aspectY:(CGFloat)y
                    aspectT:(CGFloat)t
                  jungleGym:(NSMutableDictionary *)jungleGym
          selectedGameParts:(MEGameParts *)gameParts;

- (void)fixedValuesFromToolBar:(MEMatrix *)maxM x:(CGFloat)x y:(CGFloat)y t:(CGFloat)t;

- (void)modifyMaxX:(BOOL)shouldUp;

- (void)modifyMaxY:(BOOL)shouldUp;

- (void)modifyMaxZ:(BOOL)shouldUp;

- (void)modifyCursorZ:(BOOL)shouldUp;

- (void)switchToPenMode:(int)penSize;

- (void)switchToEraserMode:(int)eraseSize;

@property int penSize;
@property int eraseSize;


- (void)putEnemyFlag;

- (void)putAllyFlag;

- (void)eraseEnemyFlag;

- (void)clearEnemyFlag;

- (void)fillLayer;

- (void)clearLayer;

- (void)syncToGameParts;

- (void)shiftUpZ;

- (NSString *)makeTagWithMatrix:(MEMatrix *)mat;
- (void)showFlags ;

@property IBOutlet NSView *targetView;

@end
