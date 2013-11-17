//
//  Zombie.m
//  SpriteKit
//
//  Created by Thomas Dupont on 17/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "Zombie.h"

#import "GameScene.h"
#import "SKSpriteNode+PhysicsDebug.h"

static NSArray* kZombieWalkingSprites = nil;
static NSArray* kZombieHeadShotSprites = nil;

static UIColor* kZombieBlendColor = nil;
static CGFloat const kZombieBlendFactor = 0.2;

@interface Zombie ()

@end

@implementation Zombie

+ (void)initialize
{
    if (self == [Zombie class])
    {
        kZombieBlendColor = [UIColor greenColor];
        
        NSMutableArray* sprites = [[NSMutableArray alloc] init];
        
        SKTextureAtlas* zombieAnimatedAtlas = [SKTextureAtlas atlasNamed:@"zombie"];
        for (int i = 1 ; i <= 8 ; i++)
        {
            NSString *textureName = [NSString stringWithFormat:@"zombie-%d", i];
            SKTexture *texture = [zombieAnimatedAtlas textureNamed:textureName];
            [sprites addObject:texture];
        }
        kZombieWalkingSprites = [sprites copy];
        
        [sprites removeAllObjects];
        
        SKTextureAtlas* zombieHeadShotAtlas = [SKTextureAtlas atlasNamed:@"zombieHeadShot"];
        for (int i = 1 ; i <= 8 ; i++)
        {
            NSString *textureName = [NSString stringWithFormat:@"zombie-HeadShot-%d", i];
            SKTexture *texture = [zombieHeadShotAtlas textureNamed:textureName];
            [sprites addObject:texture];
        }
        kZombieHeadShotSprites = [sprites copy];
    }
}

+ (instancetype)node
{
    SKTexture *texture = [kZombieWalkingSprites objectAtIndex:0];
    Zombie* zombie = [Zombie spriteNodeWithTexture:texture];
    
    zombie.color = kZombieBlendColor;
    zombie.colorBlendFactor = kZombieBlendFactor;
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(-5, 5, 10, 20)];
    
//    zombie.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:zombie.size];
    zombie.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path.CGPath];
    zombie.physicsBody.dynamic = YES;
    zombie.physicsBody.categoryBitMask = zombieCategory;
    zombie.physicsBody.contactTestBitMask = cranberryCategory;
    zombie.physicsBody.collisionBitMask = 0;
    
#ifdef SKDebug
    [zombie debugPhysicsWithPath:path];
#endif
    
    SKAction* animation = [SKAction animateWithTextures:kZombieWalkingSprites timePerFrame:0.1f resize:YES restore:NO];
    [zombie runAction:[SKAction repeatActionForever:animation]];
    
    return zombie;
}

- (void)walkWithDuration:(NSTimeInterval)duration
{
    CGPoint point = CGPointMake(- self.size.width / 2, self.position.y);
    
    SKAction * actionMove = [SKAction moveTo:point duration:duration];
    SKAction * loseAction = [SKAction runBlock:^{
        [(GameScene*)self.parent gameOverWithSuccess:NO];
    }];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [self runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
}

- (void)headShot
{
    SKTexture *temp = [kZombieHeadShotSprites objectAtIndex:0];
    SKSpriteNode* headShot = [SKSpriteNode spriteNodeWithTexture:temp];
    headShot.color = kZombieBlendColor;
    headShot.colorBlendFactor = kZombieBlendFactor;
    headShot.position = CGPointMake(self.position.x, self.position.y + 10);
    
    [self.parent addChild:headShot];
    
    SKAction* animation = [SKAction animateWithTextures:kZombieHeadShotSprites timePerFrame:0.05f resize:YES restore:NO];
    SKAction* sequence = [SKAction sequence:@[animation,
                                              [SKAction waitForDuration:1],
                                              [SKAction fadeAlphaTo:0 duration:1],
                                              [SKAction removeFromParent]]];
    [headShot runAction:sequence];
    
    [self removeFromParent];
}

@end
