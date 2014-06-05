//
//  MEMainMenu.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEMainMenu.h"
#import "METileWindowController.h"

@implementation MEMainMenu

- (id)initWithCoder:(NSCoder *)aDecoder {
    if([super initWithCoder:aDecoder]){
        self.tileWindowControllers = [NSMutableArray new];
        
        NSArray *topLevel = [NSArray new];
        if(![[NSBundle mainBundle] loadNibNamed:@"MEGamePartsEditWindowController" owner:nil topLevelObjects:&topLevel]){
            return self;
        }
        if(![[NSBundle mainBundle] loadNibNamed:@"MEGamePartsListWindowController" owner:nil topLevelObjects:&topLevel]){
            return self;
        }
        for(id obj in topLevel){
            if(NSClassFromString(@"MEGamePartsEditWindowController") == [obj class]){
                self.gamePartsEditWindowController = (MEGamePartsEditWindowController*)obj;
            }
            if(NSClassFromString(@"MEGamePartsListWindowController") == [obj class]){
                self.gamePartsListWindowController = (MEGamePartsListWindowController*)obj;
            }
        }
    }
    return self;
}

- (BOOL)validateMenuItem:(id )menuItem
{
    return YES;
}

/*ウィンドウの表示*/
- (IBAction)showGameParts:(id)sender
{
        [self.gamePartsEditWindowController.window orderFront:self];
}

/*タイルマップを開く*/
- (IBAction)openTileFile:(id)sender
{
    /*Openダイアログを表示*/
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"png",@"jpg",@"bmp",nil];
    [openPanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [openPanel runModal];
    
    if(pressedButton == NSOKButton){
        NSURL *filePath = [openPanel URL];
        NSLog(@"file opened %@",filePath);
        /*タイルウィンドウを表示*/
        [self createTileWindow:filePath];
        
    }
    
}

-(void)createTileWindow:(NSURL*)filePath
{
//    NSRect rect = NSMakeRect(0, 0, 320, 200);
    METileWindowController* w = [[METileWindowController alloc]
                                 initWithWindowNibName:@"METileWindowController" imageURL:filePath];
    [w.window makeKeyAndOrderFront:nil];
    [self.tileWindowControllers addObject:w];

#ifdef NEVER
    [[NSWindow alloc]
                   initWithContentRect:rect
                   styleMask:NSTitledWindowMask
                   backing:NSBackingStoreBuffered
                   defer:NO];
    nextTopLeft = [w cascadeTopLeftFromPoint:nextTopLeft];
    [w setTitle:NSStringFromPoint(nextTopLeft)];
    [w  makeKeyAndOrderFront:nil];
#endif
}
@end
