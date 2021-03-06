//
//  MEGameMapWindowController.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/14.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import "MEGameMapWindowController.h"
#import "MEMatrix.h"
#import "MEGameMapChipLayer.h"
#import "MEGameParts.h"

@interface MEGameMapWindowController ()
@end

@implementation MEGameMapWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName
                    fileURL:(NSURL *)url
                       maxM:(MEMatrix *)maxSize
                    aspectX:(CGFloat)x
                    aspectY:(CGFloat)y
                    aspectT:(CGFloat)t
                  jungleGym:(NSMutableDictionary *)materialGym
          selectedGameParts:(MEGameParts *)gameParts {
    NSLog(@"init");
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        [self.window setDelegate:self];

        _maxM = maxSize;
        _editMapMode = kEditMapModePenMode;

        _shouldShowGriph = YES;
        _shouldShowLines = YES;
        _shouldShowUpper = YES;

        _filePath = [url path];

        _aspectX = x;
        _aspectY = y;
        _aspectT = t;

        _penSize = 1;
        _eraseSize = 1;

        _workingEmptyCursors = [NSMutableArray array];
        _currentCursor = [[MEMatrix alloc] initWithX:0 Y:0 Z:0];
        _selectedGameParts = gameParts;
        
        _allyStartPoint2 = nil;
        _enemyStartPoints2 = [NSMutableArray array];

        if (!materialGym) {
            [self makeJungleJym];
        } else {
//            [self restoreJungleJym:materialGym];
            self.jungleJym = materialGym;
        }
        [self showTargetView];

        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(selectedGameParts:) name:@"selectedGameParts" object:nil];
    }
    return self;
}

- (NSString *)makeTagWithMatrix:(MEMatrix *)mat {
    return [NSString stringWithFormat:@"%d", (int) (mat.x + mat.y * 100 + mat.z * 10000)];
}

//新規のジャングルジム生成
- (void)makeJungleJym {
    self.jungleJym = [NSMutableDictionary dictionary];
}

//ジャングルジムの復元
- (void)restoreJungleJym:(NSMutableDictionary *)materialGym {
    self.jungleJym = [NSMutableDictionary dictionary];
    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            for (int z = 0; z < self.maxM.z; z++) {
                MEGameParts *parts = [materialGym objectForKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                                 Y:y
                                                                                                                 Z:z]]];





//                int tag = [self makeTagWithX:x y:y z:z];
                //  self.jungleJym[[NSString stringWithFormat:@"%d", tag]] = nil;
            }
        }
    }

}

//ツールバーのfixを押した
- (void)fixedValuesFromToolBar:(MEMatrix *)maxM x:(CGFloat)x y:(CGFloat)y t:(CGFloat)t {
    _maxM = maxM;
    _aspectX = x;
    _aspectY = y;
    _aspectT = t;
    [self showTargetView];
}

//ツールバーに反映
- (void)windowDidBecomeKey:(NSNotification *)notification {
    NSLog(@"map window become-- %@", notification);
    if (self.onSetToToolWindow) {
        self.onSetToToolWindow(self.maxM, self.aspectX, self.aspectY, self.aspectT, self.currentCursor);
    }
}

//GamePartsリストから選択された
- (void)selectedGameParts:(id)obj {
    NSDictionary *dict = [[obj userInfo] objectForKey:@"KEY"];
    self.selectedGameParts = [dict objectForKey:@"game_parts"];
}

//ウィンドウサイズ、viewサイズの初期化
- (void)showTargetView {
    [self clear];
    [self showBackground];
    [self showTiles];
    [self showFlags];
    [self redrawEmptyCursor:self.currentCursor.z];
}

- (void)clear {
    for (CALayer *subLayer in [self.targetView.layer.sublayers mutableCopy]) {
        [subLayer removeFromSuperlayer];
    }
}


//碁盤の目の再描画
- (void)redrawEmptyCursor:(int)beforeZ {
    //前回のものを空のカーソルだけ消去
    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            MEMatrix *mat = [[MEMatrix alloc] initWithX:x Y:y Z:beforeZ];
            MEGameParts *cube = [self.jungleJym objectForKey:[self makeTagWithMatrix:mat]];
            if (!cube) {
                MEGameMapChipLayer *child = [self.targetView.layer
                        valueForKey:[self makeTagWithMatrix:mat]];
                if (child) {
                    [child removeFromSuperlayer];
                }
                continue;
            }
        }
    }

    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            int z = self.currentCursor.z;
            MEMatrix *mat = [[MEMatrix alloc] initWithX:x Y:y Z:z];
            MEGameParts *cube = [self.jungleJym objectForKey:[self makeTagWithMatrix:mat]];
            if (cube) {
                continue;
            }
            [self drawTile:[[MEMatrix alloc] initWithX:x Y:y Z:z]];
        }
    }
}

- (void)showFlags {
    if(self.allyStartPoint2){
        [self drawFlag:self.allyStartPoint2 isEnemy:NO removeMode:NO];
    }
    for (MEMatrix *mat in self.enemyStartPoints2){
        [self drawFlag:mat isEnemy:YES removeMode:NO];
    }
}

//タイルの描画
- (void)showTiles {
    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            for (int z = 0; z < self.maxM.z; z++) {
                MEGameParts *cube = self.jungleJym[[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                     Y:y
                                                                                                     Z:z]]];
                MEGameMapChipLayer *chip = [[MEGameMapChipLayer alloc] initWithGameParts:cube
                                                                                       x:self.aspectX
                                                                                       y:self.aspectY
                                                                                       t:self.aspectT];
                CGPoint origin = [self pointOfChipPositionWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                               Y:y
                                                                                               Z:z]];
                [chip setFrame:CGRectMake(origin.x, origin.y, chip.bounds.size.width, chip.bounds.size.height)];
                [chip setZPosition:(x - y) + 1000 * (z + 1)];
                [self.targetView.layer addSublayer:chip];
                [self.targetView.layer setValue:chip forKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                              Y:y
                                                                                                              Z:z]]];
                if (cube) {
                    NSLog(@"chip bounds %f, %f", chip.bounds.size.width, chip.bounds.size.height);
                    [chip drawGameParts];
                    continue;
                }
            }
        }
    }
}

- (CGPoint)pointOfChipPositionWithMatrix:(MEMatrix *)matrix {
    CGFloat xOrigin = self.aspectX / 2.0f * matrix.x +
            self.aspectX / 2.0f * matrix.y;
    CGFloat yOrigin =
            self.aspectY / 2.0f * matrix.x * -1.0f +
                    self.aspectY / 2.0f * matrix.y +
                    self.aspectT * matrix.z;
    CGFloat yAid = [self aidOfZ0Position];
    return CGPointMake(xOrigin, yOrigin + yAid);
}

- (CGFloat)aidOfZ0Position {
    return self.aspectY / 2.0f * self.maxM.x;
}

- (CGFloat)aidOfZCurrentCursorPosition {
    return self.aspectY / 2.0f * self.maxM.x + self.currentCursor.z * self.aspectT;
}


- (void)showBackground {
    CGFloat width =
            self.aspectX / 2.0f +
                    self.aspectX / 2.0f * self.maxM.x +
                    self.aspectX / 2.0f * self.maxM.y;
    CGFloat height =
            self.aspectY / 2.0f * self.maxM.x +
                    self.aspectY + self.aspectY / 2.0f * self.maxM.y +
                    self.aspectT * self.maxM.z;
    NSLog(@"unko2 %f,%f", width, height);

    CGRect winsize = CGRectMake(0, 0, width, height);
    [self.targetView setFrame:winsize];
    [self.targetView setWantsLayer:YES];
    self.targetView.layer.backgroundColor = [[NSColor blackColor] CGColor];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    NSPoint curPoint = [theEvent locationInWindow];

    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            for (int z = 0; z < self.maxM.z; z++) {
                if (self.currentCursor.z != z) {
                    continue;
                }
                if ([MEGameMapChipLayer hitCursorPointWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                           Y:y
                                                                                           Z:z]
                                                         aspectX:self.aspectX
                                                         aspectY:self.aspectY
                                                             aid:[self aidOfZCurrentCursorPosition]
                                                     mouseCursor:curPoint
                                                    chipPosition:[self pointOfChipPositionWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                                               Y:y
                                                                                                                               Z:z]]
                ]) {
                    //クリックした場所の座標が確定
                    NSLog(@"hit %d,%d,%d", x, y, z);
                    switch (self.editMapMode) {
                        case kEditMapModePenMode:
                            for(int i = 0; i < self.penSize ; i++){
                                for(int xoffs = 0; xoffs < self.penSize; xoffs++){
                                    if((x+xoffs) >= self.maxM.x){
                                        continue;
                                    }
                                    for(int yoffs = 0; yoffs < self.penSize; yoffs++){
                                        if((y+yoffs) >= self.maxM.y){
                                            continue;
                                        }
                                        [self.jungleJym setObject:self.selectedGameParts
                                                           forKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x+xoffs
                                                                                                                    Y:y+yoffs
                                                                                                                    Z:z]]];
                                        [self drawTile:[[MEMatrix alloc] initWithX:x+xoffs
                                                                                 Y:y+yoffs
                                                                                 Z:z]];
                                    }
                                }
                            }
                            break;
                        case kEditMapModeEraserMode:
                            for(int i = 0; i < self.penSize ; i++){
                                for(int xoffs = 0; xoffs < self.penSize; xoffs++){
                                    if((x+xoffs) >= self.maxM.x){
                                        continue;
                                    }
                                    for(int yoffs = 0; yoffs < self.penSize; yoffs++){
                                        if((y+yoffs) >= self.maxM.y){
                                            continue;
                                        }
                                        [self.jungleJym removeObjectForKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x+xoffs
                                                                                                                             Y:y+yoffs
                                                                                                                             Z:z]]];
                                        [self drawTile:[[MEMatrix alloc] initWithX:x+xoffs
                                                                                 Y:y+yoffs
                                                                                 Z:z]];
                                    }
                                }
                            }
                            break;
                        case kEditMapModeAllyFlagMode:
                            _allyStartPoint2 = [[MEMatrix alloc] initWithX:x
                                                                           Y:y
                                                                           Z:z];
                                        [self drawFlag:[[MEMatrix alloc] initWithX:x
                                                                                 Y:y
                                                                                 Z:z] isEnemy:NO removeMode:NO];
                            
                            break;
                        case kEditMapModeEnemyFlagMode:
                            for(MEMatrix *pos in _enemyStartPoints2){
                                if(pos.x == x && pos.y == y && pos.z == z){
                                    [_enemyStartPoints2 removeObject:pos];
                                }
                            }
                            [_enemyStartPoints2 addObject:[[MEMatrix alloc] initWithX:x
                                                                           Y:y
                                                                                   Z:z]];
                            [self drawFlag:[[MEMatrix alloc] initWithX:x
                                                                     Y:y
                                                                     Z:z] isEnemy:YES removeMode:NO];

                            break;
                        case kEditMapModeEraserEnemyFlagMode:
                            for(MEMatrix *pos in _enemyStartPoints2){
                                if(pos.x == x && pos.y == y && pos.z == z){
                                    [_enemyStartPoints2 removeObject:pos];
                                }
                            }
                            [self drawFlag:[[MEMatrix alloc] initWithX:x
                                                                     Y:y
                                                                     Z:z] isEnemy:YES removeMode:YES];
                            break;
                    }
                }
            }
        }
    }
}

- (void)drawFlag:(MEMatrix *)mat_ isEnemy:(BOOL)isEnemy removeMode:(BOOL)removeMode{
    MEMatrix *mat = [[MEMatrix alloc] initWithX:mat_.x Y:mat_.y Z:mat_.z];
    mat.z++;
    MEGameMapChipLayer *chip = [self.targetView.layer valueForKey:[self makeTagWithMatrix:mat]];
    [chip removeFromSuperlayer];
    if(removeMode){
        return;
    }

    chip = [[MEGameMapChipLayer alloc] initWithGameParts:nil
                                                       x:self.aspectX
                                                       y:self.aspectY
                                                       t:self.aspectT];
    CGPoint origin = [self pointOfChipPositionWithMatrix:mat];
    [chip setFrame:CGRectMake(origin.x, origin.y, chip.bounds.size.width, chip.bounds.size.height)];
    [chip setZPosition:(mat.x - mat.y) + 1000 * (mat.z + 1)];
    [self.targetView.layer addSublayer:chip];
    [self.targetView.layer setValue:chip forKey:[self makeTagWithMatrix:mat]];
    
    [chip drawFlag:isEnemy];
}

- (void)drawTile:(MEMatrix *)mat {
    MEGameMapChipLayer *chip = [self.targetView.layer valueForKey:[self makeTagWithMatrix:mat]];
    [chip removeFromSuperlayer];
    chip = nil;

    MEGameParts *cube = [self.jungleJym objectForKey:[self makeTagWithMatrix:mat]];
    chip = [[MEGameMapChipLayer alloc] initWithGameParts:cube
                                                       x:self.aspectX
                                                       y:self.aspectY
                                                       t:self.aspectT];
    CGPoint origin = [self pointOfChipPositionWithMatrix:mat];
    [chip setFrame:CGRectMake(origin.x, origin.y, chip.bounds.size.width, chip.bounds.size.height)];
    [chip setZPosition:(mat.x - mat.y) + 1000 * (mat.z + 1)];
    [self.targetView.layer addSublayer:chip];
    [self.targetView.layer setValue:chip forKey:[self makeTagWithMatrix:mat]];
    if (!cube) {
        [chip drawEmptyCursor];
    } else {
        [chip drawGameParts];
    }
}

- (void)modifyMaxX:(BOOL)shouldUp {
    if (shouldUp) {
        self.maxM.x++;
        if (self.maxM.x > 100) {
            self.maxM.x = 100;
        }
    } else {
        self.maxM.x--;
        if (self.maxM.x < 1) {
            self.maxM.x = 1;
        }
    }
    if (self.onSetToToolWindow) {
        self.onSetToToolWindow(self.maxM, self.aspectX, self.aspectY, self.aspectT, self.currentCursor);
    }
    [self showTargetView];
}

- (void)modifyMaxY:(BOOL)shouldUp {
    if (shouldUp) {
        self.maxM.y++;
        if (self.maxM.y > 100) {
            self.maxM.y = 100;
        }
    } else {
        self.maxM.y--;
        if (self.maxM.y < 1) {
            self.maxM.y = 1;
        }
    }
    if (self.onSetToToolWindow) {
        self.onSetToToolWindow(self.maxM, self.aspectX, self.aspectY, self.aspectT, self.currentCursor);
    }
    [self showTargetView];
}

- (void)modifyMaxZ:(BOOL)shouldUp {
    if (shouldUp) {
        self.maxM.z++;
        if (self.maxM.z > 100) {
            self.maxM.z = 100;
        }
    } else {
        self.maxM.z--;
        if (self.maxM.z < 1) {
            self.maxM.z = 1;
        }
    }
    if (self.onSetToToolWindow) {
        self.onSetToToolWindow(self.maxM, self.aspectX, self.aspectY, self.aspectT, self.currentCursor);
    }
    [self showTargetView];
}

- (void)modifyCursorZ:(BOOL)shouldUp {
    int beforeZ = self.currentCursor.z;
    if (shouldUp) {
        self.currentCursor.z++;
        if (self.maxM.z <= self.currentCursor.z) {
            self.currentCursor.z = self.maxM.z - 1;
        }
    } else {
        self.currentCursor.z--;
        if (self.currentCursor.z < 0) {
            self.currentCursor.z = 0;
        }
    }
    if (self.onSetToToolWindow) {
        self.onSetToToolWindow(self.maxM, self.aspectX, self.aspectY, self.aspectT, self.currentCursor);
    }
    [self redrawEmptyCursor:beforeZ];
}


- (void)putAllyFlag{
    self.editMapMode = kEditMapModeAllyFlagMode;
}

- (void)putEnemyFlag{
    self.editMapMode = kEditMapModeEnemyFlagMode;
}

- (void)clearEnemyFlag{
    [self.enemyStartPoints2 removeAllObjects];
}

- (void)eraseEnemyFlag{
    self.editMapMode = kEditMapModeEraserEnemyFlagMode;
}


- (void)switchToPenMode:(int)penSize {
    self.editMapMode = kEditMapModePenMode;
    self.penSize = penSize;
}

- (void)switchToEraserMode:(int)eraseSize {
    self.editMapMode = kEditMapModeEraserMode;
    self.eraseSize = eraseSize;
}

- (void)shiftUpZ {
    [self modifyMaxZ:YES];
    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            for (int z = (self.maxM.z - 1); z >= 0; z--) {
                if ([self.jungleJym objectForKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                   Y:y
                                                                                                   Z:z - 1]]]) {
                    MEGameParts *cube =
                            [[self.jungleJym objectForKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                   Y:y
                                                                                                   Z:z - 1]]] copy];
                    [self.jungleJym setObject:cube
                                       forKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                Y:y
                                                                                                Z:z]]];
                    [self.jungleJym removeObjectForKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                         Y:y
                                                                                                         Z:z-1]]];
                    continue;
                }
            }
        }
    }
    [self showTargetView];
}

- (void)fillLayer {
    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            if ([self.jungleJym objectForKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                               Y:y
                                                                                               Z:self.currentCursor.z]]]) {
                continue;
            }
            [self.jungleJym setObject:self.selectedGameParts
                               forKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                        Y:y
                                                                                        Z:self.currentCursor.z]]];
        }
    }
    [self showTargetView];
}

- (void)clearLayer {
    for (int x = 0; x < self.maxM.x; x++) {
        for (int y = 0; y < self.maxM.y; y++) {
            if ([self.jungleJym objectForKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                               Y:y
                                                                                               Z:self.currentCursor.z]]]) {
                [self.jungleJym removeObjectForKey:[self makeTagWithMatrix:[[MEMatrix alloc] initWithX:x
                                                                                                     Y:y
                                                                                                     Z:self.currentCursor.z]]];
            }
        }
    }
    [self showTargetView];
}

- (void)syncToGameParts {
    [self showTargetView];
}
@end
