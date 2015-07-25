//
//  MEMEGamePartsListWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MEGamePartsViewController.h"

@interface MEGamePartsListWindowController : NSWindowController

@property MEGamePartsViewController *gamePartsViewController;

//@property IBOutlet NSView	*targetView;
@property IBOutlet NSTabView	*tabView;
@property IBOutlet NSTextField *selectionField;


@end
