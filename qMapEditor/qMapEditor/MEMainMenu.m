//
//  MEMainMenu.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEMainMenu.h"

@implementation MEMainMenu

- (id)init{
    self = [super init];
        
    [self setAutoenablesItems:YES];
    [self.itemCreateGameParts setTarget:self];
    
    return self;
}

- (BOOL)validateMenuItem:(id )menuItem
{
    return YES;
}

- (IBAction)createGameParts:(id)sender
{

}
@end
