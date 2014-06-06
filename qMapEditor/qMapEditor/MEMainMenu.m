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
        NSArray *topLevel2 = [NSArray new];
        if(![[NSBundle mainBundle] loadNibNamed:@"MEGamePartsEditWindowController" owner:nil topLevelObjects:&topLevel]){
            NSLog(@"unko1");
            return self;
        }
        NSLog(@"aaa%@",topLevel);
        for(id obj in topLevel){
            if(NSClassFromString(@"MEGamePartsEditWindowController") == [obj class]){
                NSLog(@"unko3");
                self.gamePartsEditWindowController = (MEGamePartsEditWindowController*)obj;
            }
        }

        if(![[NSBundle mainBundle] loadNibNamed:@"MEGamePartsListWindowController" owner:nil topLevelObjects:&topLevel2]){
            NSLog(@"unko2");
            return self;
        }
        NSLog(@"aaa2%@",topLevel2);
        for(id obj in topLevel2){
            if(NSClassFromString(@"MEGamePartsListWindowController") == [obj class]){
                NSLog(@"unko4");
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
    __block MEMainMenu *blockself = self;
    NSLog(@"aho %@",blockself.gamePartsEditWindowController);
    METileWindowController* w = [[METileWindowController alloc]
                                 initWithWindowNibName:@"METileWindowController"
                                 imageURL:filePath
                                 onPickUp:^(NSImage *image){
                                     NSLog(@"aho %@ :%@",image,blockself.gamePartsEditWindowController);
                                     [blockself.gamePartsEditWindowController setTopViewWithImage:image];
                                 }];
    [w.window makeKeyAndOrderFront:nil];
    [self.tileWindowControllers addObject:w];

}
@end
