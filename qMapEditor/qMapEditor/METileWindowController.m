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
        self.widthCellsNum.stringValue = @"1";
        self.heightCellsNum.stringValue = @"1";
    }
    NSLog(@"aho1");
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self showContent];
    NSRect frame = [self.targetView frame];
    frame.size.height += [self.window frame].size.height - [[self.window contentView] frame].size.height;
    [self.window setFrame:frame display:NO];
}

- (void)showContent {
    NSLog(@"showContent: %@",[self.imageURL absoluteString]);
    NSImage *image = [[NSImage alloc] initByReferencingURL:self.imageURL];
    self.imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    
 //   [self.imageView setAlignment:NSLeftTextAlignment];
    [self.imageView setImageScaling:NSScaleNone];
    [self.imageView setImage:image];
    
    [self.targetView setFrame:[self.imageView frame]];
    [self.targetView addSubview:self.imageView];
    
    
    
}

- (void)clearLine
{
    NSRect imageRect;
    imageRect.origin = (NSPoint){0.0f,0.0f};
    imageRect.size = self.imageView.image.size;
    
    [[NSColor clearColor] set];
    NSRectFill(imageRect);

}

- (IBAction)pushFixButton:(id)sender
{
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [self showContent];
    
    int widthNum_ = [self.widthCellsNum.stringValue intValue];
    int heightNum_ = [self.heightCellsNum.stringValue intValue];
    if(!(widthNum_>0 && heightNum_>0)){
        return;
    }
    
    widthNum = widthNum_;
    heightNum = heightNum_;
    
    [self.imageView.image lockFocus];
    

    
    float widthVolume = [self.imageView image].size.width / widthNum;
    float heightVolume = [self.imageView image].size.height / heightNum;

    //縦線
    for (int x = 1; x < widthNum; x++) {
            NSPoint from = NSMakePoint(NSMinX([self.imageView bounds])+widthVolume*x,
                                       NSMinY([self.imageView bounds]));
            NSPoint to = NSMakePoint(NSMinX([self.imageView bounds])+widthVolume*x,
                                      NSMaxY([self.imageView bounds]));
          [self drawLine:from to:to];
            

    }
    //横線
  for (int y = 1; y < heightNum; y++) {
      NSPoint from = NSMakePoint(NSMinX([self.imageView bounds]),
                                 NSMinY([self.imageView bounds])+heightVolume*y);
      NSPoint to = NSMakePoint(NSMaxX([self.imageView bounds]),
                                NSMinY([self.imageView bounds])+heightVolume*y);
    [self drawLine:from to:to];
  }
    [self.imageView.image unlockFocus];
    
    [self.drawView setNeedsDisplay:YES];
}
- (void)drawLine:(NSPoint)from to:(NSPoint)to
{
        NSBezierPath *line = [NSBezierPath bezierPath];
    [line moveToPoint:from];
    [line lineToPoint:to];
    [line setLineWidth:1.0]; /// Make it easy to see
    [[NSColor blueColor] set];
    //    [[self lineColor] set]; /// Make future drawing the color of lineColor.
    [line stroke];
}

@end
