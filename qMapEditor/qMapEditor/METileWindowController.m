//
//  METileWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/06.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "METileWindowController.h"
#import "MEGameParts.h"

@interface METileWindowController ()

@end

@implementation METileWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName
                   imageURL:(NSURL *)url
                   onPickUp:(void (^)(METile *tile))pickup {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        self.imageURL = url;
        self.widthCellsNum.stringValue = @"1";
        self.heightCellsNum.stringValue = @"1";
        self.onPickUp = pickup;
        self.readyToPickUp = false;
    }
    return self;
}

- (id)initWithWindowNibName:(NSString *)windowNibName
                   imageURL:(NSURL *)url
                   widthNum:(NSInteger)widthNum_
                  heightNum:(NSInteger)heightNum_
                   onPickUp:(void (^)(METile *tile))pickup {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        self.imageURL = url;
        self.widthCellsNum.stringValue = [NSString stringWithFormat:@"%d", widthNum_];
        self.heightCellsNum.stringValue = [NSString stringWithFormat:@"%d", heightNum_];
        self.onPickUp = pickup;
        self.readyToPickUp = true;
        widthNum = widthNum_;
        heightNum = heightNum_;
    }
    return self;
}

-(void)drawLineAfterLoad{
    [self showContent];
    [self drawLine];
}

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self showContent];
    NSRect frame = [self.targetView frame];
    frame.size.height += [self.window frame].size.height - [[self.window contentView] frame].size.height;
    [self.window setFrame:frame display:NO];
}

- (void)showContent {
    NSLog(@"showContent: %@", [self.imageURL absoluteString]);
    NSImage *image = [[NSImage alloc] initByReferencingURL:self.imageURL];
    self.imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];

    [self.imageView setImageScaling:NSScaleNone];
    [self.imageView setImage:image];

    [self.targetView setFrame:[self.imageView frame]];
    [self.targetView addSubview:self.imageView];
}

//線引きボタン
- (IBAction)pushFixButton:(id)sender {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [self showContent];

    int widthNum_ = [self.widthCellsNum.stringValue intValue];
    int heightNum_ = [self.heightCellsNum.stringValue intValue];
    if (!(widthNum_ > 0 && heightNum_ > 0)) {
        self.readyToPickUp = false;
        return;
    }
    self.readyToPickUp = true;

    widthNum = widthNum_;
    heightNum = heightNum_;

    [self drawLine];
}

- (void)drawLine{
    [self.imageView.image lockFocus];

    CGFloat widthVolume = [self.imageView image].size.width / widthNum;
    CGFloat heightVolume = [self.imageView image].size.height / heightNum;

    NSLog(@"w:%d,h:%d",widthNum,heightNum);
    NSLog(@"%@",self.imageView.image);

    //縦線
    for (int x = 1; x < widthNum; x++) {
        NSPoint from = NSMakePoint(NSMinX([self.imageView bounds]) + widthVolume * x,
                NSMinY([self.imageView bounds]));
        NSPoint to = NSMakePoint(NSMinX([self.imageView bounds]) + widthVolume * x,
                NSMaxY([self.imageView bounds]));
        [self _drawLine:from to:to];
    }
    //横線
    for (int y = 1; y < heightNum; y++) {
        NSPoint from = NSMakePoint(NSMinX([self.imageView bounds]),
                NSMinY([self.imageView bounds]) + heightVolume * y);
        NSPoint to = NSMakePoint(NSMaxX([self.imageView bounds]),
                NSMinY([self.imageView bounds]) + heightVolume * y);
        [self _drawLine:from to:to];
    }

    [self.imageView.image unlockFocus];
    [self.imageView setNeedsDisplay:YES];
}


- (void)_drawLine:(NSPoint)from to:(NSPoint)to {
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line moveToPoint:from];
    [line lineToPoint:to];
    [line setLineWidth:1.0]; /// Make it easy to see
    [[NSColor blueColor] set];
    [line stroke];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (!self.readyToPickUp) {
        return;
    }
    NSPoint location = [self.imageView convertPoint:[theEvent locationInWindow] fromView:nil];

    CGFloat widthVolume = [self.imageView image].size.width / widthNum;
    CGFloat heightVolume = [self.imageView image].size.height / heightNum;

    for (int x = 0; x < widthNum; x++) {
        for (int y = 0; y < heightNum; y++) {
            if (location.x >= x * widthVolume && location.x < (x + 1) * widthVolume &&
                    location.y >= y * heightVolume && location.y < (y + 1) * heightVolume
                    ) {
                //切り取って渡す
                self.onPickUp([[METile alloc] initWithURL:self.imageURL
                                                     rect:CGRectMake(x * widthVolume,
                                                             y * heightVolume,
                                                             widthVolume,
                                                             heightVolume)]);
            }
        }
    }
}


#ifdef NEVER
- (NSImage *)pickUpImageWithFrame:(CGRect)frame {
    //NSImage *image = [[NSImage alloc] initWithSize:frame.size];
    NSImage *image = [[NSImage alloc] initByReferencingURL:self.imageURL];
    [image setSize:frame.size];
    [image lockFocus];
    [self.imageView.image drawInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)
                            fromRect:frame
                           operation:NSCompositeCopy
                            fraction:1.0f];
    [image unlockFocus];
//    [self.imageView setImage:image];
    return image;
}
#endif

@end
