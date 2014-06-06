//
//  METileWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/06.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface METileWindowController : NSWindowController{
    int widthNum;
    int heightNum;
}

@property IBOutlet NSView	*targetView;
@property IBOutlet NSToolbar *toolBar;
@property IBOutlet NSTextField *widthCellsNum;
@property IBOutlet NSTextField *heightCellsNum;
@property IBOutlet NSButton *fixButton;

@property NSURL *imageURL;
@property NSImageView *imageView;
@property NSView *drawView;

- (id)initWithWindowNibName:(NSString *)windowNibName imageURL:(NSURL*)url;
- (void)showContent;
- (IBAction)pushFixButton:(id)sender;

@end
