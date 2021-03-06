//
//  MEGamePartsEditWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/05.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGamePartsEditWindowController.h"
#import "MEGameParts.h"
#import "MEAnimationBaseView.h"
#import "MECategoryTableView.h"
#import <QuartzCore/QuartzCore.h>

@interface MEGamePartsEditWindowController () <NSTableViewDataSource, NSTableViewDelegate>
@end

@implementation MEGamePartsEditWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        //        self.topImageView = [[NSImageView alloc] initWithFrame:self.topView.bounds];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

        // 通知センターに通知要求を登録する
        // この例だと、通知センターに"Tuchi"という名前の通知がされた時に、
        // hogeメソッドを呼び出すという通知要求の登録を行っている。
        [nc addObserver:self selector:@selector(selectedGameParts:) name:@"selectedGameParts" object:nil];

        NSNib *cellNib = [[NSNib alloc] initWithNibNamed:@"MECategoryTableViewCell" bundle:nil];
        [self.categoryTableView registerNib:cellNib forIdentifier:@"category_"];

        self.categoryTableView.dataSource = self;
        self.categoryTableView.delegate = self;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.categoryTableView reloadData];
}

- (void)awakeFromNib {
    [self.categoryTableView reloadData];
}


- (void)runAnimation {
//    [CATransaction begin];
    [self.topImageView setWantsLayer:YES];

    CALayer *animationLayer = [CALayer layer];
    animationLayer.frame = self.topImageView.bounds;
    [self.topImageView.layer addSublayer:animationLayer];

    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];

    NSMutableArray *array = [NSMutableArray array];
    CGImageRef maskRef;
    for (METile *tile in buildingGameParts.tiles) {
        NSImage *someImage = [tile image];
        CGImageSourceRef source;
        source = CGImageSourceCreateWithData((__bridge CFDataRef) [someImage TIFFRepresentation], NULL);
        maskRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        [array addObject:(__bridge id) (maskRef)];
    }

    NSLog(@"array:%@", array);
    keyAnimation.values = (NSArray *) array;
    keyAnimation.duration = 1.0f;
    keyAnimation.repeatCount = HUGE_VALF;
    [keyAnimation setCalculationMode:kCAAnimationDiscrete];

    [animationLayer addAnimation:keyAnimation forKey:@"aho2"];
//    [CATransaction commit];
}

- (void)updateAnimationBaseView {
    //アニメーションあり
    int idx = 0;
    for (METile *tile in buildingGameParts.tiles) {
        NSLog(@"idx:%d", idx);
        CGFloat widthVolume = 50.0f;
        CGFloat heightVolume = 50.0f;
        NSImageView *imageView = [[NSImageView alloc]
                initWithFrame:CGRectMake(widthVolume * (idx % 5), heightVolume * (idx / 5), widthVolume, heightVolume)];
        [imageView setImage:[tile image]];
        [self.animationViewBase addSubview:imageView];
        idx++;
    }
}

- (void)_setParamsFromUI {
    buildingGameParts.walkable = [self.walkable state] == NSOnState;
    buildingGameParts.snow = [self.snowButton state] == NSOnState;
    buildingGameParts.half = [self.half state] == NSOnState;
    buildingGameParts.rezoTypeRect = ([self.rezoType state] == NSOnState) ? kRezoTypeRect64 : kRezoTypeRect32;
    buildingGameParts.pavementType = self.pavementControl.selectedSegment;
    buildingGameParts.watertype = self.waterRadioGroup.selectedRow;
    
    buildingGameParts.harfIdName = self.harfIdTextField.selectedCell.title;

    NSMutableArray *macroTypes = [@[] mutableCopy];
    if (self.macroRoad.state == NSOnState) {
        [macroTypes addObject:@(kMacroTypeRoad)];
    }
    if (self.macroRaugh.state == NSOnState) {
        [macroTypes addObject:@(kMacroTypeRough)];
    }
    if (self.macroWall.state == NSOnState) {
        [macroTypes addObject:@(kMacroTypeWall)];
    }
    if (self.macroCantEnter.state == NSOnState) {
        [macroTypes addObject:@(kMacroTypeCantEnter)];
    }
    if (self.macroOther.state == NSOnState) {
        [macroTypes addObject:@(kMacroTypeOther)];
    }

    buildingGameParts.macroTypes = macroTypes;
//    [buildingGameParts.categories addObject:<#(id)anObject#>];
}

//セットアップ
- (void)setViewWithGameParts:(MEGameParts *)gameParts {
    NSAssert(gameParts, @"gameParts should not nil");
    buildingGameParts = nil;
    buildingGameParts = gameParts;

    int i = 0;
    for (CALayer *layer in [self.topImageView.layer.sublayers mutableCopy]) {
        [layer removeAllAnimations];
    }
    for (NSView *subView in [self.animationViewBase.subviews mutableCopy]) {
        NSLog(@"idx1:%d", i++);
        [subView removeFromSuperview];
    }
    if ([buildingGameParts.tiles count] > 1) {
        [self updateAnimationBaseView];
        [self.topImageView setImage:[[buildingGameParts.tiles lastObject] image]];
        [self runAnimation];
    } else {
        NSLog(@"updated imageView");
        [self.topImageView setImage:[buildingGameParts image]];
        if (self.animationViewBase.editable) {
            [self updateAnimationBaseView];
        }
    }
    [buildingGameParts initSampleImageWithKVO:NO];

    [self _setParamsFromUI];
    [self.categoryTableView reloadData];

    NSLog(@"topImageView  id;%@ %@", self.topImageView, self.topImageView.image);
}

//タイルが指定された
- (void)setViewWithTile:(METile *)tile {
//    NSAssert(tile, @"tile should not nil");
    NSMutableArray *tiles = [[NSMutableArray alloc] initWithArray:buildingGameParts.tiles];
    [tiles addObject:tile];

    if (!buildingGameParts) {
        buildingGameParts = [[MEGameParts alloc] initWithTiles:tiles
                                                      walkable:YES
                                                     waterType:0
                                                      duration:0
                                                          half:NO
                                                      rezoType:kRezoTypeRect32
                                                    categories:nil
                                                  pavementType:kPavementTypeNone
                                                    macroTypes:@[]
                                                          snow:NO
                                                    harfIdName:@""
                                                  customEvents:nil];
    }
    if (self.animationViewBase.editable) {
        buildingGameParts.tiles = nil;
        buildingGameParts.tiles = tiles;
    } else {
        buildingGameParts.tiles = nil;
        buildingGameParts.tiles = [NSMutableArray arrayWithObjects:tile, nil];
    }

    [self setViewWithGameParts:buildingGameParts];
}

//リストから選択された
- (void)selectedGameParts:(id)obj {
    NSDictionary *dict = [[obj userInfo] objectForKey:@"KEY"];
    MEGameParts *parts = [dict objectForKey:@"game_parts"];
    NSLog(@"selectedGameParts,%@", parts);

    self.walkable.state = parts.walkable ? NSOnState : NSOffState;
    self.snowButton.state = parts.snow? NSOnState : NSOffState;
    self.half.state = parts.half ? NSOnState : NSOffState;
    self.harfIdTextField.selectedCell.title = parts.harfIdName ? : @"";
    
    self.rezoType.state = (parts.rezoTypeRect == kRezoTypeRect64) ? NSOnState : NSOffState;

    self.pavementControl.selectedSegment = parts.pavementType;
    self.macroRoad.state = NSOffState;
    self.macroRaugh.state = NSOffState;
    self.macroWall.state = NSOffState;
    self.macroCantEnter.state = NSOffState;
    self.macroOther.state = NSOffState;
    
    for (NSNumber *macroType in parts.macroTypes) {
        switch (macroType.integerValue) {
            case kMacroTypeRoad:
                self.macroRoad.state = NSOnState;
                break;
            case kMacroTypeRough:
                self.macroRaugh.state = NSOnState;
                break;
            case kMacroTypeWall:
                self.macroWall.state = NSOnState;
                break;
            case kMacroTypeCantEnter:
                self.macroCantEnter.state = NSOnState;
                break;
            case kMacroTypeOther:
                self.macroOther.state = NSOnState;
                break;
        }
    }

    [self.waterRadioGroup setState:1 atRow:parts.watertype column:0];
    [self setViewWithGameParts:[parts copy]];
    if (self.onSelectedGameParts) {
        self.onSelectedGameParts([buildingGameParts copy]);
    }
}

//pavement選択
- (IBAction)didChanged:(id)sender {
    if ([sender isKindOfClass:[NSSegmentedControl class]]) {
        NSSegmentedControl *segmentedControl = (NSSegmentedControl *) sender;
        buildingGameParts.pavementType = segmentedControl.selectedSegment;
    }
}

//Addボタン：GameParts追加
- (IBAction)pushedAddGameParts:(id)sender {
    if (!buildingGameParts.categories || !buildingGameParts.categories.count) {
        return;
    }
    NSLog(@"topImageView2 id;%@ %@", self.topImageView, self.topImageView.image);
    [self _setParamsFromUI];

    self.onRegistGameParts([buildingGameParts copy]);
}

//Modifyボタン：GameParts上書き
- (IBAction)pushedModifyGameParts:(id)sender {
    if (!buildingGameParts.categories || !buildingGameParts.categories.count) {
        return;
    }
    [self _setParamsFromUI];
    self.onUpdateGameParts([buildingGameParts copy]);
}

//deleteボタン：GameParts削除
- (IBAction)pushedDeleteGameParts:(id)sender {
    self.onDeleteGameParts();
}
//GamePartsロード

//animボタン
- (IBAction)pushedSwitchAnimMode:(id)sender {
    [self.animationViewBase switchMode];
    if (self.animationViewBase.editable) {
        [self.modeLabel setStringValue:@"Select any tile to add animation."];
    } else {
        [self.modeLabel setStringValue:@"disable"];
    }
}

//clearボタン
- (IBAction)pushedClearAnim:(id)sender {
    [buildingGameParts.tiles removeAllObjects];
    [self setViewWithGameParts:buildingGameParts];
}

//ラジオボタン
- (IBAction)pushedRadioCell:(id)sender {
    NSInteger tag;
    tag = [[self.waterRadioGroup selectedCell] tag];
    NSLog(@"selected tag:%d", tag);
    switch (tag) {
        case 1:
            buildingGameParts.watertype = kWaterTypeWater;
            break;
        case 2:
            buildingGameParts.watertype = kWaterTypePoison;
            break;
        case 3:
            buildingGameParts.watertype = kWaterTypeFlame;
            break;
        case 4:
            buildingGameParts.watertype = kWaterTypeHeal;
            break;
        default:
            buildingGameParts.watertype = kWaterTypeNone;
            break;
    }
}

#pragma mark - tableview delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [MECategory existCategories].count;
}

#if 0
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
#if 1
    MECategoryTableViewCell *cell = [aTableView makeViewWithIdentifier:@"categoryCell" owner:nil];
    [cell.textField setStringValue:[MECategory existCategories][rowIndex]];
    return cell;
#else
    NSLog(@"aTableColumn:%@, row:%d, category:%@",[aTableColumn identifier], rowIndex, [MECategory existCategories][rowIndex]);
    return [MECategory existCategories][rowIndex];
#endif
}
#endif

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    MECategoryTableViewCell *cell = [tableView makeViewWithIdentifier:@"category_" owner:self];
    [cell.textField setStringValue:[MECategory existCategories][row]];
    [cell.imageView.layer setBackgroundColor:[NSColor redColor].CGColor];
    for (NSString *category in [MECategory existCategories]) {
        for (NSString *category_ in buildingGameParts.categories) {
            if ([category isEqualToString:category_]) {
                [cell.textField.layer setBackgroundColor:[NSColor blueColor].CGColor];
            }
        }
    }
    return cell;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
    buildingGameParts.categories = [@[] mutableCopy];
    [buildingGameParts.categories addObject:[MECategory existCategories][rowIndex]];
    return YES;
}


@end
