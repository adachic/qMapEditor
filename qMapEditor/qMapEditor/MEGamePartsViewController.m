//
//  MEGamePartsViewController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/06.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsViewController.h"
#import "MEGameParts.h"

@implementation IconViewBox

- (NSView *)hitTest:(NSPoint)aPoint
{
    // don't allow any mouse clicks for subviews in this NSBox
    return nil;
}

@end

@interface MEGamePartsViewController ()

@end

@implementation MEGamePartsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

#define KEY_GAMEPARTS	@"game_parts"
#define KEY_NAME	@"name"

- (void)awakeFromNib
{
    // save this for later when toggling between alternate colors
    savedAlternateColors = [collectionView backgroundColors];

    [self setSortingMode:0];		// icon collection in ascending sort order
    [self setAlternateColors:YES];	// no alternate background colors (initially use gradient background)

#ifdef NEVER
    // Determine the content of the collection view by reading in the plist "icons.plist",
    // and add extra "named" template images with the help of NSImage class.
    //
    NSBundle		*bundle = [NSBundle mainBundle];
    NSString		*path = [bundle pathForResource: @"icons" ofType: @"plist"];
    NSArray			*iconEntries = [NSArray arrayWithContentsOfFile: path];
    NSMutableArray	*tempArray = [[NSMutableArray alloc] init];

    // read the list of icons from disk in 'icons.plist'
    if (iconEntries != nil)
    {
        NSInteger idx;
        NSInteger count = [iconEntries count];
        for (idx = 0; idx < count; idx++)
        {
            NSDictionary *entry = [iconEntries objectAtIndex:idx];
            if (entry != nil)
            {
                NSString *codeStr = [entry valueForKey: KEY_IMAGE];
                NSString *iconName = [entry valueForKey: KEY_NAME];

                OSType code = UTGetOSTypeFromString((CFStringRef)codeStr);
                NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
                [tempArray addObject: [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        picture, KEY_IMAGE,
                        iconName, KEY_NAME,
                        nil]];
            }
        }
    }

    // now add named image templates
    [tempArray addObject: [NSMutableDictionary dictionaryWithObjectsAndKeys:
            [NSImage imageNamed:NSImageNameIconViewTemplate], KEY_IMAGE,
            NSImageNameIconViewTemplate, KEY_NAME,
            nil]];

    [self setGamePartsArray:tempArray];
#endif
//    self.gamePartsArray

    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
}

- (void)addGameParts:(MEGameParts*)gameParts{
    NSLog(@"gameparts:%@, %@",gameParts,gameParts.imageView.image);
    /*
    NSView *view = [[NSView alloc] initWithFrame:gameParts.imageView.frame];
    [view addSubview:gameParts.imageView];
    */
    if(!self.gamePartsArray){
        NSMutableArray	*tempArray = [[NSMutableArray alloc] init];
        [tempArray addObject: [NSMutableDictionary dictionaryWithObjectsAndKeys:
                gameParts.imageView.image, KEY_GAMEPARTS,
                @"aho", KEY_NAME,
                nil]];
        [self setGamePartsArray:tempArray];
    }else{
        NSMutableArray	*tempArray = [[NSMutableArray alloc] init];
        [tempArray addObjectsFromArray:self.gamePartsArray];
        [tempArray addObject: [NSMutableDictionary dictionaryWithObjectsAndKeys:
                gameParts.imageView.image, KEY_GAMEPARTS,
                @"aho", KEY_NAME,
                nil]];
        [self setGamePartsArray:tempArray];
    }
}

- (void)setAlternateColors:(BOOL)useAlternateColors
{
    alternateColors = useAlternateColors;
    if (alternateColors)
    {
        [collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor gridColor], [NSColor lightGrayColor], nil]];
    }
    else
    {
        [collectionView setBackgroundColors:savedAlternateColors];
    }
}

- (void)setSortingMode:(BOOL)shouldAcending
{
    sortingModeIsAcending = shouldAcending;
    //文字列の大小を比較
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
            initWithKey:KEY_NAME
              ascending:sortingModeIsAcending
               selector:@selector(caseInsensitiveCompare:)];
    [arrayController setSortDescriptors:[NSArray arrayWithObject:sort]];
}


@end


@implementation MyScrollView

- (void)awakeFromNib
{
    // set up the background gradient for this custom scrollView
    backgroundGradient = [[NSGradient alloc] initWithStartingColor:
                          [NSColor colorWithDeviceRed:0.349f green:0.6f blue:0.898f alpha:0.0f]
                                                       endingColor:[NSColor colorWithDeviceRed:0.349f green:0.6f blue:.898f alpha:0.6f]];
}

- (void)drawRect:(NSRect)rect
{
    // draw our special background as a gradient
    [backgroundGradient drawInRect:[self documentVisibleRect] angle:90.0f];
}

- (void)dealloc
{
}

@end

