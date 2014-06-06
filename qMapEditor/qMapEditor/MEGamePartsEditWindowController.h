//
//  MEGamePartsEditWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MEGamePartsEditWindowController : NSWindowController

- (void)setTopViewWithImage:(NSImage *)tile;

@property IBOutlet NSImageView *topImageView;

@property IBOutlet NSView *topView;

@end
