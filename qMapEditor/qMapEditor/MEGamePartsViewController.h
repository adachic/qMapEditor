//
//  MEGamePartsViewController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/06.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MEGameParts;

@interface IconViewBox : NSBox

@property IBOutlet id delegate;

@end

@interface MyScrollView : NSScrollView {
    NSGradient *backgroundGradient;
}
@end

@interface MEGamePartsViewController : NSViewController <NSCollectionViewDelegate> {
    IBOutlet NSCollectionView *collectionView;
    IBOutlet NSArrayController *arrayController;
    NSMutableArray *gamePartsArray;

    BOOL sortingModeIsAcending;
    BOOL alternateColors;

    NSArray *savedAlternateColors;
}

- (void)setArray:(NSArray*)array;

@property(retain) NSMutableArray *gamePartsArray;
@property(nonatomic, assign) NSUInteger sortingMode;
@property(nonatomic, assign) BOOL alternateColors;
@property(nonatomic, assign) BOOL showWalkable;
@property(nonatomic) NSString *category;

- (void)addGameParts:(MEGameParts *)gameParts;
- (void)updateGameParts:(MEGameParts*)gameParts;
- (void)deleteGameParts;
- (BOOL)hasCategory:(MEGameParts *)gameParts;

- (void)showUpdate;

- (MEGameParts *)searchItemWithName:(NSString*)name;
- (MEGameParts *)selectedGameParts;
@end


