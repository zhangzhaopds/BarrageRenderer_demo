//
//  ViewController.m
//  BarrageRenderer_demo
//
//  Created by 张昭 on 05/12/2016.
//  Copyright © 2016 张昭. All rights reserved.
//

#import "ViewController.h"
#import <BarrageRenderer.h>
#import "SafeObject.h"
#import "UIImage+Barrage.h"
#import "AdvancedBarrageController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) BarrageRenderer *renderer;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    SafeObject *safeObj = [[SafeObject alloc] initWithObject:self withSelector:@selector(autoSendBarrage)];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.renderer stop];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    [self initBarrageRenderer];
}

- (void)initBarrageRenderer {
    self.renderer = [[BarrageRenderer alloc] init];
    [self.view addSubview:self.renderer.view];
    self.renderer.canvasMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // 弹幕的点击事件,并在Descriptor中注入行为
    self.renderer.view.userInteractionEnabled = YES;
    
    [self.view sendSubviewToBack:self.renderer.view];
    
}

- (void)autoSendBarrage {
    NSInteger spriteNumber = [self.renderer spritesNumberWithName:nil];
    self.infoLabel.text = [NSString stringWithFormat:@"当前屏幕弹幕数量：%ld", spriteNumber];
    
    if (spriteNumber < 500) {
        
        // 过场文字
        [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionL2R]];
        [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
        
        
        // 浮动文字
        [self.renderer receive:[self floatTextSpriteDescriptorWithDirection:BarrageFloatDirectionB2T]];
        [self.renderer receive:[self floatTextSpriteDescriptorWithDirection:BarrageFloatDirectionT2B]];
        
        // 过场图片
        [self.renderer receive:[self walkImageSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
        
        // 悬浮图片
        [self.renderer receive:[self floatImageSpriteDescriptorWithDirection:BarrageFloatDirectionB2T]];
        
    }
}

/// 生成精灵描述 - 过场图片弹幕
- (BarrageDescriptor *)walkImageSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkImageSprite class]);
    descriptor.params[@"image"] = [[UIImage imageNamed:@"avatar"]barrageImageScaleToSize:CGSizeMake(20.0f, 20.0f)];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"trackNumber"] = @5; // 轨道数量
    return descriptor;
}

/// 生成精灵描述 - 浮动图片弹幕
- (BarrageDescriptor *)floatImageSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageFloatImageSprite class]);
    descriptor.params[@"image"] = [[UIImage imageNamed:@"avatar"]barrageImageScaleToSize:CGSizeMake(40.0f, 15.0f)];
    descriptor.params[@"duration"] = @(3);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}


/// 生成精灵描述 - 浮动文字弹幕
- (BarrageDescriptor *)floatTextSpriteDescriptorWithDirection:(NSInteger)direction {
    
    BarrageDescriptor *descriptor = [[BarrageDescriptor alloc] init];
    descriptor.spriteName = NSStringFromClass([BarrageFloatTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"悬浮文字弹幕:%ld",(long)_index++];
    descriptor.params[@"textColor"] = [UIColor purpleColor];
//    descriptor.params[@"duration"] = @(3);
    descriptor.params[@"fadeInTime"] = @(1);
    descriptor.params[@"fadeOutTime"] = @(1);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}

// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction {
    BarrageDescriptor *descriptor = [[BarrageDescriptor alloc] init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"过场文字精灵：%ld", self.index++];
    
    // 文字颜色
    descriptor.params[@"textColor"] = [UIColor blueColor];
    
    // 弹幕速度
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    
    // 弹幕方向
    descriptor.params[@"direction"] = @(direction);
    
    // 轨道数量
//    descriptor.params[@"trackNumber"] = @5;
    
    // 精灵点击事件
    descriptor.params[@"clickAction"] = ^{
        NSLog(@"点击了过场文字精灵");
    };
    
    return descriptor;
}

// 开始
- (IBAction)startBtnClicked:(UIButton *)sender {
    [self.renderer start];
}

// 暂停
- (IBAction)pauseBtnClicked:(UIButton *)sender {
    [self.renderer pause];
}

// 恢复
- (IBAction)resumeBtnClicked:(UIButton *)sender {
    [self.renderer start];
}

// 停止
- (IBAction)stopBtnClicked:(UIButton *)sender {
    [self.renderer stop];
}

// 减速
- (IBAction)slowerBtnClicked:(UIButton *)sender {
    CGFloat speed = _renderer.speed - 0.5;
    if (speed <= 0.5f) {
        speed = 0.5;
    }
    _renderer.speed = speed;
}

// 加速
- (IBAction)fasterBtnClicked:(UIButton *)sender {
    CGFloat speed = _renderer.speed + 0.5;
    if (speed >= 10) {
        speed = 10.0f;
    }
    _renderer.speed = speed;
}

- (IBAction)nextClicked:(UIButton *)sender {
//    AdvancedBarrageController *ad = [[AdvancedBarrageController alloc] init];
//    [self presentViewController:ad animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
