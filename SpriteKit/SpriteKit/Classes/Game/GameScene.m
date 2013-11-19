//
//  GameScene.m
//  SpriteKit
//
//  Created by Thomas Dupont on 16/11/2013.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"

#import "SKSpriteNode+PhysicsDebug.h"

#import "Zombie.h"
#import "Cranberry.h"

static NSInteger const kGameSceneKilledZombiesToWin = 100;

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property (nonatomic, assign) NSInteger killedZombies;
@property (nonatomic, assign) NSInteger shootedCranberries;

@property (nonatomic, strong) SKNode* gameNode;

@end

@implementation GameScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [UIColor blackColor];
        
        SKSpriteNode* street = [SKSpriteNode spriteNodeWithImageNamed:@"street"];
        street.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        street.color = [UIColor blackColor];
        street.colorBlendFactor = 0.3;
        [self addChild:street];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        self.gameNode = [SKNode node];
        [self addChild:self.gameNode];
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"particle" ofType:@"sks"];
        SKEmitterNode* emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        emitter.particlePosition = CGPointMake(size.width/2, size.height);
        [self addChild:emitter];
    }
    return self;
}

#pragma mark - Update

- (void)update:(NSTimeInterval)currentTime
{
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    
    if (timeSinceLast > 1)
    {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    
    CGFloat duration = MAX(0.5, 2 - ((self.killedZombies / 3) * 0.1));
    
    if (self.lastSpawnTimeInterval > duration)
    {
        self.lastSpawnTimeInterval = 0;
        [self addZombie];
    }
}

#pragma mark - Logic

- (void)addZombie
{
    Zombie* zombie = [Zombie node];
    
    int rangeY = self.frame.size.height - zombie.size.height;
    int y = (arc4random() % rangeY) + zombie.size.height / 2;
    
    zombie.position = CGPointMake(self.frame.size.width + zombie.size.width/2, y);
    zombie.zPosition = self.frame.size.height - y;
    
    [self.gameNode addChild:zombie];
    
    CGFloat minDuration = MAX(2.0, 4.0 - ((self.killedZombies / 3) * 0.1));
    CGFloat duration = (arc4random() % 2) + minDuration;
    
    [zombie walkWithDuration:duration];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.shootedCranberries++;
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (location.x > 0)
    {
        Cranberry* cranberry = [Cranberry node];
        cranberry.position = CGPointMake(0, self.frame.size.height / 2);
        
        [self.gameNode addChild:cranberry];
        
        [cranberry shootToPoint:location];
    }
}

- (void)gameOverWithSuccess:(BOOL)success
{
    UIColor* fadeColor = nil;
    
    if (success)
    {
        fadeColor = [UIColor blackColor];
    }
    else
    {
        fadeColor = [UIColor redColor];
    }
    
    SKTransition *transition = [SKTransition fadeWithColor:fadeColor duration:0.5];
    SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size
                                                              won:success
                                                     zombieKilled:self.killedZombies
                                               cranberriesShooted:self.shootedCranberries];
    [self.view presentScene:gameOverScene transition:transition];
}

#pragma mark - Contact

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody* firstBody = nil;
    SKPhysicsBody* secondBody = nil;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & cranberryCategory) != 0 && (secondBody.categoryBitMask & zombieCategory) != 0)
    {
        [self cranberry:(Cranberry*)firstBody.node didCollideWithZombie:(Zombie*)secondBody.node];
    }
}

- (void)cranberry:(Cranberry*)cranberry didCollideWithZombie:(Zombie*)zombie
{
    [zombie headShot];
    [cranberry removeFromParent];
    
    self.killedZombies++;
    
    if (self.killedZombies >= kGameSceneKilledZombiesToWin)
    {
        [self gameOverWithSuccess:YES];
    }
}

@end
