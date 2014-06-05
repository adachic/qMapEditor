//
//  MEMEGamePartsListWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsListWindowController.h"

@interface MEGamePartsListWindowController ()

@end

@implementation MEGamePartsListWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib
{
    NSLog(@"hoge");
    //[[self window] setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
    //[[self window] setContentBorderThickness:50 forEdge:NSMinYEdge];
    
    
    [self willChangeValueForKey:@"gamePartsViewController"];
     self.gamePartsViewController = [[MEGamePartsViewController alloc] initWithNibName:@"Collection" bundle:nil];
     [self didChangeValueForKey:@"gamePartsViewController"];
    
    
    [self.targetView addSubview:[self.gamePartsViewController view]];
    
    
    // make sure we resize the viewController's view to match its super view
    [[self.gamePartsViewController view] setFrame:[self.targetView bounds]];
    
    return;

#if 0
    [self.gamePartsViewController setSortingMode:0];		// ascending sort order
    [self.gamePartsViewController setAlternateColors:NO];	// no alternate background colors (initially use gradient background)
#endif
}

@end
