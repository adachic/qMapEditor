//
//  METileWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/06.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class METile;

@interface METileWindowController : NSWindowController {
    int widthNum;
    int heightNum;
}
typedef void (^_onPickUp)(METile *tile);

@property IBOutlet NSView *targetView;
@property IBOutlet NSToolbar *toolBar;
@property IBOutlet NSTextField *widthCellsNum;
@property IBOutlet NSTextField *heightCellsNum;
@property IBOutlet NSButton *fixButton;

@property NSURL *imageURL;
@property NSImageView *imageView;
@property NSView *drawView;
@property bool readyToPickUp;

@property(copy) _onPickUp onPickUp;

- (id)initWithWindowNibName:(NSString *)windowNibName
                   imageURL:(NSURL *)url
                   onPickUp:(void (^)(METile *tile))pickup;

- (id)initWithWindowNibName:(NSString *)windowNibName
                   imageURL:(NSURL *)url
                   widthNum:(NSInteger)widthNum_
                  heightNum:(NSInteger)heightNum_
                   onPickUp:(void (^)(METile *tile))pickup;

- (void)showContent;
-(void)drawLineAfterLoad;

- (IBAction)pushFixButton:(id)sender;

@end
