//
//  METileWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/06.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface METileWindowController : NSWindowController

@property IBOutlet NSView	*targetView;

@property NSURL *imageURL;
@property NSImageView *imageView;


- (id)initWithWindowNibName:(NSString *)windowNibName imageURL:(NSURL*)url;
- (void)showContent;

@end
