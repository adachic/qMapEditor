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

@property(retain) NSMutableArray *gamePartsArray;
@property(nonatomic, assign) NSUInteger sortingMode;
@property(nonatomic, assign) BOOL alternateColors;

- (void)addGameParts:(MEGameParts *)gameParts;
@end


