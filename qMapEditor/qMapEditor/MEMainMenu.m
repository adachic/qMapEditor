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
    self = [super initWithCoder:aDecoder];
    return self;
}

- (BOOL)validateMenuItem:(id )menuItem
{
    return YES;
}

- (IBAction)createGameParts:(id)sender
{
    if(!self.gamePartsEditWindow){
        NSArray *topLevel = [NSArray new];
        [[NSBundle mainBundle] loadNibNamed:@"MEGamePartsEditWindow" owner:nil topLevelObjects:&topLevel];
        self.gamePartsEditWindow = (MEGamePartsEditWindow*)[topLevel lastObject];
        [self.gamePartsEditWindow orderFront:self];
    }
}
@end
