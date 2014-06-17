//
//  MEGameMapWindowController.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MEMatrix;


@interface MEGameMapWindowController : NSWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName
                    fileURL:(NSURL *)url;

@property MEMatrix *maxM;

@property BOOL shouldShowUpper;
@property BOOL shouldShowGriph;
@property BOOL shouldShowLines;

@end
