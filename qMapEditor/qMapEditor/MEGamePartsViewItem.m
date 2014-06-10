//
//  MEGamePartsViewItem.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/10.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsViewItem.h"

@interface MEGamePartsViewItem ()

@end

@implementation MEGamePartsViewItem

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        NSLog(@"aho rep:%@",self.representedObject);
    }
    return self;
}

- (id)init {
    self = [super init];
    NSLog(@"init called");
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent{
    //選択状態にする
    
    
    NSLog(@"unko, %@",self.representedObject);
}


- (void)setSelected:(BOOL)flag {
        NSLog(@"unko2");
}
@end
