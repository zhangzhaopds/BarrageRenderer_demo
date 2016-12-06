//
//  AdvancedBarrageController.m
//  BarrageRenderer_demo
//
//  Created by 张昭 on 06/12/2016.
//  Copyright © 2016 张昭. All rights reserved.
//

#import "AdvancedBarrageController.h"
#import "UIImage+Barrage.h"
#import <BarrageRenderer/BarrageRenderer.h>
#import "BarrageWalkImageTextSprite.h"

@interface AdvancedBarrageController ()<BarrageRendererDelegate>

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) BarrageRenderer *renderer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSTimeInterval predictedTime;

@end

@implementation AdvancedBarrageController

- (void)dealloc {
    [self.renderer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 0;
    self.predictedTime = 0.0f;
    [self initBarrageRenderer];
}

- (void)initBarrageRenderer {
    self.renderer = [[BarrageRenderer alloc] init];
    self.renderer.delegate = self;
    self.renderer.redisplay = YES;
    [self.view addSubview:self.renderer.view];
    [self.view sendSubviewToBack:self.renderer.view];
}

// 开始
- (IBAction)startBtnClicked:(UIButton *)sender {
    self.startTime = [NSDate date];
    [self.renderer start];
}

// 图文混合A
- (IBAction)hybridABtnClicked:(UIButton *)sender {
    [_renderer receive:[self walkImageTextSpriteDescriptorAWithDirection:BarrageWalkDirectionR2L]];
}

// 图文混合B
- (IBAction)hybridBBtnClicked:(UIButton *)sender {
    [_renderer receive:[self walkImageTextSpriteDescriptorBWithDirection:BarrageWalkDirectionL2R]];
}

// 返回
- (IBAction)backBtnClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 加载
- (IBAction)loadBtnClicked:(UIButton *)sender {
    NSInteger const number = 10;
    NSMutableArray * descriptors = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < number; i++) {
        [descriptors addObject:[self walkTextSpriteDescriptorWithDelay:i*2+1]];
    }
    [_renderer load:descriptors];
}

// 快进
- (IBAction)forewardClicked:(UIButton *)sender {
    self.predictedTime = self.predictedTime + 5.0f;
}

// 后退
- (IBAction)backwardClicked:(UIButton *)sender {
//    self.predictedTime = self.predictedTime - 5.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 生成精灵描述 - 延时文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDelay:(NSTimeInterval)delay
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"延时弹幕(延时%.0f秒):%ld",delay,(long)_index++];
    descriptor.params[@"textColor"] = [UIColor blueColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(1);
    descriptor.params[@"delay"] = @(delay);
    return descriptor;
}

/// 图文混排精灵弹幕 - 过场图文弹幕A
- (BarrageDescriptor *)walkImageTextSpriteDescriptorAWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkImageTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"AA-图文混排/::B过场弹幕:%ld",(long)_index++];
    descriptor.params[@"textColor"] = [UIColor greenColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}

/// 图文混排精灵弹幕 - 过场图文弹幕B
- (BarrageDescriptor *)walkImageTextSpriteDescriptorBWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"AA-图文混排/::B过场弹幕:%ld",(long)_index++];
    descriptor.params[@"textColor"] = [UIColor greenColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    
    NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
    attachment.image = [[UIImage imageNamed:@"avatar"]barrageImageScaleToSize:CGSizeMake(25.0f, 25.0f)];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:
                                              [NSString stringWithFormat:@"BB-图文混排过场弹幕:%ld",(long)_index++]];
    [attributed insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:7];
    
    descriptor.params[@"attributedText"] = attributed;
    descriptor.params[@"textColor"] = [UIColor magentaColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}

#pragma mark - BarrageRendererDelegate

- (NSTimeInterval)timeForBarrageRenderer:(BarrageRenderer *)renderer
{
    NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:_startTime];
    interval += _predictedTime;
    return interval;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
