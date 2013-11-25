//
//  LoadingScene.m
//  SpriteKit
//
//  Created by Thomas Dupont on 25/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "LoadingScene.h"

#import "GameScene.h"

@interface LoadingScene ()

@property (nonatomic, strong) UITapGestureRecognizer* tap;
@property (nonatomic, strong) SKSpriteNode* logoSprite;

@end

@implementation LoadingScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.logoSprite = [SKSpriteNode spriteNodeWithImageNamed:@"cocoaheads"];
        self.logoSprite.position = CGPointMake(self.logoSprite.size.width / 2, size.height / 2);
        
        [self addChild:self.logoSprite];
    }
    return self;
}

- (void)didMoveToView:(SKView*)view
{
    SKLabelNode *startLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    startLabel.text = @"Démarrer";
    startLabel.fontSize = 20;
    startLabel.fontColor = [UIColor blackColor];
    startLabel.position = CGPointMake(self.logoSprite.size.width + (self.size.width - self.logoSprite.size.width) / 2, self.size.height / 2);
    startLabel.alpha = 0;
    [self addChild:startLabel];
    
    SKAction* waitAction = [SKAction waitForDuration:1.0];
    SKAction* blockAction = [SKAction runBlock:^{
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:self.tap];
    }];
    SKAction* fadeAction = [SKAction fadeAlphaTo:1 duration:1];
    
    SKAction* sequence = [SKAction sequence:@[waitAction, blockAction, fadeAction]];
    [startLabel runAction:sequence];
}

- (void)handleTap:(UITapGestureRecognizer*)tap
{
    [self.view removeGestureRecognizer:self.tap];
    SKTransition *transition = [SKTransition fadeWithDuration:0.5];
    SKScene * myScene = [[GameScene alloc] initWithSize:self.size];
    [self.view presentScene:myScene transition:transition];
}

@end
