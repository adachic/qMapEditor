//
//  MEMEGamePartsListWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsListWindowController.h"
#import "MEGameParts.h"

@interface MEGamePartsTabViewItem : NSTabViewItem
@property MEGamePartsViewController *gamePartsViewController;
@end

@implementation MEGamePartsTabViewItem
- (instancetype)initWithIdentifier:(id)gamePartsViewController {
    self = [super initWithIdentifier:gamePartsViewController];
    if (self) {
        self.gamePartsViewController = gamePartsViewController;
        self.view = [gamePartsViewController view];
    }
    return self;
}
@end

@interface MEGamePartsListWindowController ()<NSTabViewDelegate>
@end

@implementation MEGamePartsListWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _gamePartsViewControllers = [@[] mutableCopy];
    }

    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib {
    NSLog(@"hoge");
    //[[self window] setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
    //[[self window] setContentBorderThickness:50 forEdge:NSMinYEdge];

#ifdef NEVER
    [self willChangeValueForKey:@"gamePartsViewController"];
    self.gamePartsViewController = [[MEGamePartsViewController alloc] initWithNibName:@"Collection" bundle:nil];
    [self didChangeValueForKey:@"gamePartsViewController"];

    [self.targetView addSubview:[self.gamePartsViewController view]];

    // make sure we resize the viewController's view to match its super view
    [[self.gamePartsViewController view] setFrame:[self.targetView bounds]];
#endif
    for (NSString *categoryName in [MECategory existCategories]) {
        MEGamePartsViewController *gamePartsViewController = [[MEGamePartsViewController alloc] initWithNibName:@"Collection" bundle:nil];
        MEGamePartsTabViewItem *tabViewItem = [[MEGamePartsTabViewItem alloc] initWithIdentifier:gamePartsViewController];
        [[gamePartsViewController view] setFrame:[self.tabView bounds]];

        tabViewItem.label = categoryName;
        gamePartsViewController.category = categoryName;

       // [gamePartsViewController setSortingMode:0];        // ascending sort order
       // [gamePartsViewController setAlternateColors:NO];    // no alternate background colors (initially use gradient background)

        [self.tabView addTabViewItem:tabViewItem];
        [self.gamePartsViewControllers addObject:gamePartsViewController];
    }
}

- (void)addGameParts:(MEGameParts *)gameParts {
    for(MEGamePartsViewController *gamePartsViewController in self.gamePartsViewControllers){
        if(![gamePartsViewController hasCategory:gameParts]){
            continue;
        }
        [gamePartsViewController addGameParts:gameParts];
    }
}

- (void)updateGameParts:(MEGameParts *)gameParts {
    for(MEGamePartsViewController *gamePartsViewController in self.gamePartsViewControllers){
        if(![gamePartsViewController hasCategory:gameParts]){
            continue;
        }
        [gamePartsViewController updateGameParts:gameParts];
    }
}

- (void)deleteGameParts {
    MEGamePartsTabViewItem *tabViewItem = (MEGamePartsTabViewItem *)[self.tabView selectedTabViewItem];
    [tabViewItem.gamePartsViewController deleteGameParts];
}

- (MEGameParts *)selectedGameParts{
    MEGamePartsTabViewItem *tabViewItem = (MEGamePartsTabViewItem *)[self.tabView selectedTabViewItem];
    return [tabViewItem.gamePartsViewController selectedGameParts];
}

- (MEGameParts *)searchItemWithName:(NSString*)name{
    MEGameParts *item = nil;
    for(MEGamePartsViewController *gamePartsViewController in self.gamePartsViewControllers){
        item = [gamePartsViewController searchItemWithName:name];
        if(item){
            return item;
        }
    }
    return nil;
}

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(MEGamePartsTabViewItem *)tabViewItem{
    [tabViewItem.gamePartsViewController.view needsLayout];
    [tabViewItem.gamePartsViewController.view display];
    [tabViewItem.gamePartsViewController.view layout];

    [tabViewItem.gamePartsViewController showUpdate];
}

@end




