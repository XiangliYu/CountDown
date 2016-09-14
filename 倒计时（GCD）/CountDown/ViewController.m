//
//  ViewController.m
//  CountDown
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 LoveSpending. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UILabel *timeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.timeLabel = [[UILabel alloc] initWithFrame:(CGRect){0,200,self.view.frame.size.width,50}];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.timeLabel];
    
    __block NSUInteger timeout = 10000000; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI的改变一定要在主线程中进行
                self.timeLabel.text = @"已结束";
                
            });
        }else{
            
            //单位换算
            NSUInteger day  = (NSUInteger)timeout/(24*3600);
            NSUInteger hour = (NSUInteger)(timeout%(24*3600))/3600;
            NSUInteger min  = (NSUInteger)(timeout%(3600))/60;
            NSUInteger second = (NSUInteger)(timeout%60);
            
            NSString *time = [NSString stringWithFormat:@"%.2lu天 %.2lu:%.2lu:%.2lu",(unsigned long)day,(unsigned long)hour,(unsigned long)min,(unsigned long)second];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.timeLabel.text = time;
            });
            
            timeout--;
            
        }
    });
    dispatch_resume(_timer);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
