//
//  MEGamePartsViewItem.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/10.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MEGamePartsViewController.h"

@interface MEGamePartsViewItem : NSCollectionViewItem

- (void)mouseDown:(NSEvent *)theEvent;
- (void)modifyed;
@end
