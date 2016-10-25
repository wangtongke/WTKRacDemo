//
//  TwoViewController.m
//  RACDemo
//
//  Created by 王同科 on 16/9/5.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "TwoViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EXTScope.h"
#import "RACReturnSignal.h"
@interface TwoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindMethod];
}

#pragma mark - bind
- (void)bindMethod
{
/**
    假设想监听文本框的内容，并且在每次输出结果的时候，都在文本框的内容拼接一段文字“输出：”
 */
//    ******************方式1、 在返回结果后拼接
//    [_textField.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"输出：%@",x);
//    }];
    
//    ******************方式2、在返回结果前拼接，使用RAC中的bind方法做处理
/**
    bind方法参数：需要传入一个返回值是RACSignalBindBlock的block参数
    RACStreamBindBlock是一个block类型，返回值是信号，参数（Value，stop），因此参数的block返回值也是一个block
 
 
    RACStreamBindBlock：
    参数一（value）：表示接受到信号的原始值，还没有做处理 
    参数二（*stop）: 用来控制绑定block，如果*stop = YES,那么久结束绑定
    返回值：信号，做好处理，再通过这个信号返回出去，一般使用RACReturnSignal，需要手动导入头文件RACReturnSignal.h
 
 
    bind方法使用步骤
    1、传入一个返回值RACStreamBindBlock的block
    2、描述一个RACStreamBindBlock类型的bindBlock作为block的返回值
    3、描述
 */
    [[_textField.rac_textSignal bind:^RACStreamBindBlock{
        
        return ^RACStream *(id value,BOOL *stop){
            return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
        };
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}



//- (void)initialBind
//{
//    RACCommand *reuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        
//        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            
//            
//            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//            parameters[@"q"] = @"基础";
//            
//            // 发送请求
//            [[AFHTTPRequestOperationManager manager] GET:@"https://api.douban.com/v2/book/search" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                NSLog(@"%@",responseObject);
//                
//                // 请求成功调用
//                // 把数据用信号传递出去
//                [subscriber sendNext:responseObject];
//                
//                [subscriber sendCompleted];
//                
//                
//            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//                // 请求失败调用
//                
//            }];
//            
//            return nil;
//        }];
//        
//        
//        
//        
//        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
//        return [requestSignal map:^id(NSDictionary *value) {
//            NSMutableArray *dictArr = value[@"books"];
//            
//            // 字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
//            NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
//                
//                return [Book bookWithDict:value];
//            }] array];
//            
//            return modelArr;
//        }];
//        
//    }];
//    
//}


- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
