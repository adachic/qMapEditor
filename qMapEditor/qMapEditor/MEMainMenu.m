//
//  MEMainMenu.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEMainMenu.h"

@implementation MEMainMenu

- (id)initWithCoder:(NSCoder *)aDecoder {
    if([super initWithCoder:aDecoder]){
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

- (IBAction)showGameParts:(id)sender
{
        [self.gamePartsEditWindowController.window orderFront:self];
}
@end
