//
//  METileWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/06.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "METileWindowController.h"

@interface METileWindowController ()

@end

@implementation METileWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName imageURL:(NSURL*)url
{
    self = [super initWithWindowNibName:windowNibName];
    if(self){
        self.imageURL = url;
    }
    NSLog(@"aho1");
    return self;
}



- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self showContent];
}

- (void)showContent {
    NSLog(@"showContent: %@",[self.imageURL absoluteString]);
    NSImage *image = [[NSImage alloc] initByReferencingURL:self.imageURL];
    self.imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    
    [self.imageView setAlignment:NSLeftTextAlignment];
    [self.imageView setImageScaling:NSScaleNone];
    [self.imageView setImage:image];
    
    [self.targetView addSubview:self.imageView];
    [self.targetView setFrame:[self.imageView bounds]];
    [self.window setFrame:[self.targetView frame] display:YES];
}
@end
