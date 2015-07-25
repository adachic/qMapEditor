//
//  MEGamePartsViewController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/06.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsViewController.h"
#import "MEGameParts.h"

@implementation IconViewBox

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    // check for click count above one, which we assume means it's a double click
    if (self.delegate && [self.delegate respondsToSelector:@selector(mouseDown:)]) {
        [self.delegate performSelector:@selector(mouseDown:) withObject:theEvent];
    }
}

/*
- (NSView *)hitTest:(NSPoint)aPoint {
    // don't allow any mouse clicks for subviews in this NSBox
    return self;
}
*/

@end

@interface MEGamePartsViewController ()

@end

@implementation MEGamePartsViewController

@synthesize gamePartsArray, sortingMode, alternateColors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

#define KEY_GAMEPARTS    @"game_parts"
#define KEY_NAME    @"name"

- (void)awakeFromNib {
    // save this for later when toggling between alternate colors
    savedAlternateColors = [collectionView backgroundColors];

    [self setSortingMode:0];        // icon collection in ascending sort order
    [self setAlternateColors:NO];    // no alternate background colors (initially use gradient background)


    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
            [[MEGameParts alloc] initWithTiles:[NSArray arrayWithObjects:[[METile alloc]
                                      initWithURL:[[NSURL alloc] initWithString:@"file:///Users/adachic/Desktop/78003b0a-s.jpg"]
                                             rect:CGRectMake(0, 0, 100, 100)], nil]
                                      walkable:NO
                                          waterType:0
                                      duration:0
                    half:NO
                rezoType:kRezoTypeRect32
                                  customEvents:nil], KEY_GAMEPARTS,
            @"aho", KEY_NAME,
            nil]];
    [self setGamePartsArray:tempArray];
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
}

- (void)addGameParts:(MEGameParts *)gameParts {
    [gameParts initSampleImageWithKVO:YES];
    if (!self.gamePartsArray) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [tempArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                gameParts, KEY_GAMEPARTS,
                gameParts.name, KEY_NAME,
                nil]];
        [self setGamePartsArray:tempArray];
    } else {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [tempArray addObjectsFromArray:self.gamePartsArray];
        [tempArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                gameParts, KEY_GAMEPARTS,
                gameParts.name, KEY_NAME,
                nil]];
        [self setGamePartsArray:tempArray];
    }
}
- (MEGameParts *)selectedGameParts{
    NSMutableDictionary *dict = [arrayController.selectedObjects lastObject];
    return [dict objectForKey:@"game_parts"];
}

- (void)updateGameParts:(MEGameParts *)gameParts {
    NSMutableDictionary *dict = [arrayController.selectedObjects lastObject];
    MEGameParts *oldParts = [dict objectForKey:@"game_parts"];

    [oldParts refOf:gameParts];
    [oldParts initSampleImageWithKVO:YES];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:self.gamePartsArray];
    [self setGamePartsArray:tempArray];
}

- (void)deleteGameParts {
    NSMutableDictionary *dict = [arrayController.selectedObjects lastObject];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:self.gamePartsArray];
    [tempArray removeObject:dict];
    [self setGamePartsArray:tempArray];
}

- (void)setAlternateColors:(BOOL)useAlternateColors {
    alternateColors = useAlternateColors;
    if (alternateColors) {
        [collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor gridColor], [NSColor lightGrayColor], nil]];
    }
    else {
        [collectionView setBackgroundColors:savedAlternateColors];
    }
}

- (void)setShowWalkable:(BOOL)showWalkable{
    if(showWalkable){
        [arrayController setFilterPredicate:[NSPredicate predicateWithFormat:@"walkable == YES"]];
    }else{
        [arrayController setFilterPredicate:[NSPredicate predicateWithFormat:@"walkable == NO"]];
    }
}

- (void)setSortingMode:(BOOL)shouldAcending {
    sortingModeIsAcending = shouldAcending;
    //文字列の大小を比較
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
            initWithKey:KEY_NAME
              ascending:sortingModeIsAcending
               selector:@selector(caseInsensitiveCompare:)];
    [arrayController setSortDescriptors:[NSArray arrayWithObject:sort]];
}

- (MEGameParts *)searchItemWithName:(NSString*)name{
    MEGameParts *ret = nil;
    for(NSMutableDictionary *dict in self.gamePartsArray){
        MEGameParts *gp = [dict objectForKey:KEY_GAMEPARTS];
        if([gp.name isEqualToString:name]){
            ret = gp;
            break;
        }
    }
    return ret;
}


@end


@implementation MyScrollView

- (void)awakeFromNib {
    // set up the background gradient for this custom scrollView
    backgroundGradient = [[NSGradient alloc] initWithStartingColor:
            [NSColor colorWithDeviceRed:0.349f green:0.6f blue:0.898f alpha:0.0f]
                                                       endingColor:[NSColor colorWithDeviceRed:0.349f green:0.6f blue:.898f alpha:0.6f]];
}

- (void)drawRect:(NSRect)rect {
    // draw our special background as a gradient
    [backgroundGradient drawInRect:[self documentVisibleRect] angle:90.0f];
}

- (void)dealloc {
}

@end

