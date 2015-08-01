//
//  MEMEGamePartsListWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsListWindowController.h"
#import "MEGameParts.h"

@interface MEGamePartsListWindowController () <NSTabViewDelegate>
@property NSString *category;
@end

@implementation MEGamePartsListWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName
                   category:(NSString *)category {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        _category = category;
    }
    return self;
}

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
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

#if 1
    [self willChangeValueForKey:@"gamePartsViewController"];
    self.gamePartsViewController = [[MEGamePartsViewController alloc] initWithNibName:@"Collection" bundle:nil];
    self.gamePartsViewController.category = self.category;
    [self didChangeValueForKey:@"gamePartsViewController"];

    [self.targetView addSubview:[self.gamePartsViewController view]];

    // make sure we resize the viewController's view to match its super view
    [[self.gamePartsViewController view] setFrame:[self.targetView bounds]];
#endif
#if 0

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
#endif
}

- (void)addGameParts:(MEGameParts *)gameParts {
    if (![self.gamePartsViewController hasCategory:gameParts]) {
        return;
    }
    [self.gamePartsViewController addGameParts:gameParts];
}

- (void)updateGameParts:(MEGameParts *)gameParts {
    if (![self.gamePartsViewController hasCategory:gameParts]) {
        return;
    }
    [self.gamePartsViewController updateGameParts:gameParts];
}

- (void)deleteGameParts {
    [self.gamePartsViewController deleteGameParts];
}

- (MEGameParts *)selectedGameParts {
    return [self.gamePartsViewController selectedGameParts];
}

- (MEGameParts *)searchItemWithName:(NSString *)name {
    MEGameParts *item = nil;
    
        item = [self.gamePartsViewController searchItemWithName:name];
        if (item) {
            return item;
        }
       return nil;
}


@end




