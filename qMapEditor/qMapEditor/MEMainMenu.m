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
        if(![[NSBundle mainBundle] loadNibNamed:@"MEGamePartsEditWindow" owner:nil topLevelObjects:&topLevel]){
            return self;
        }
        for(id obj in topLevel){
            if(NSClassFromString(@"MEGamePartsEditWindow") != [obj class]){
                continue;
            }
            self.gamePartsEditWindow = (MEGamePartsEditWindow*)obj;
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
        [self.gamePartsEditWindow orderFront:self];
}
@end
