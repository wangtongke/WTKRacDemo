//
//  ViewController.m
//  RACDemo
//
//  Created by 王同科 on 16/8/29.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "WTKViewController.h"
#import "WTKView.h"
#import "EXTScope.h"
#import "TwoViewController.h"
@interface ViewController ()
@property(nonatomic,strong)RACCommand *command;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property(nonatomic,copy)NSString *user;
@property (weak, nonatomic) IBOutlet UIView *wtkView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

//    [self RACSignalMethod];

//    信号
//    [self RACSubjectAndRACReplaySubject];
    
//    RACSequence使用
//    [self RACSequenceDemo];
    
    
//    RACCommand
//    [self RACCommandDemo];
    
//    RACMulticastConnection
//    [self RACMulticastConnectionDemo];
    
//    RAC常见用法
//    [self RACMethod];
    
    
//    RAC常见宏
//    [self RACHong];
    
    RAC(self,user) = self.textField.rac_textSignal;
    
    @weakify(self);
    RACSignal *signal = [self.textField.rac_textSignal map:^id(NSString *value) {
        @strongify(self);
        NSLog(@"1");
        if ([value isEqualToString:@"123"])
        {
            return @(NO);
        }
        return @(YES);

    }];

    
    RAC(self.wtkView,backgroundColor) = [signal map:^id(id value) {
        if ([value boolValue])
        {
            return [UIColor yellowColor];
        }
        else
        {
            return [UIColor redColor];
        }
    }];

//    RAC(self.wtkView,backgroundColor) = [signal map:^id(id value) {
//        NSLog(@"2----%@",value);
//        if ([value boolValue])
//        {
//            return [UIColor yellowColor];
//        }
//        else
//        {
//            return [UIColor redColor];
//        }
//    }];

}
- (IBAction)NEXTClick:(id)sender {
    WTKViewController *vc = [[WTKViewController alloc]init];
    
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
    [vc.delegateSubject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    

}
- (IBAction)two:(id)sender {
    TwoViewController *vc = [[TwoViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - RACSignal

- (void)RACSignalMethod
{
    //    RACSignal使用步骤
    /**
     *1.创建信号
     *2.订阅信号(订阅信号后，才会被激活)
     *3.发送信号
     
     
     /RACSignal底层实现
     1、创建信号，首先把didSubscribe保存到信号中，还不会触发
     2、当信号被订阅，也就是调用signal的subscribrNext：nextBlock， subscribeNext内部会创建订阅者subscriber，并把nextBlock保存到subscriber中，subscribNext内部会调用signal的didSubscribe
     3、signal的didsubcribe中调用【subscriber sendNext：@1】，sendNext底层其实就是执行subscriber的nextBlock。
     
     */
    
    //    1.创建信号
    RACSignal *signal   = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //        block调用时刻：每当有订阅者订阅信号，就会调用block
        
        //        2 发送信号
        [subscriber sendNext:@1];
        
        NSLog(@"111-------------");
        
        //      如果不再发送数据，最好调用发送信号完成方法，内部会自动调用[RACDisposable disposable]
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"111信号被销毁");
        }];
    }];
    
    //    3.订阅信号，才会激活信号
    [signal subscribeNext:^(id x) {
        NSLog(@"111接受到数据:%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"222jiehsoushuji---%@",x);
    }];
}


// RACSubject和RACReplaySubject的简单使用
#pragma mark - RACSubjectAnd RACRepalySubject
- (void)RACSubjectAndRACReplaySubject
{
//    RACSubject使用步骤
/**
    1、创建信号 【RACSubject subject】，跟RACSignal不一样，创建信号时没有block。
    2、订阅信号 -（RACDisposable *）subscribeNext:(void(^)(id x)nextBlock)
    3、发送信号 sengNext:(id Value)
 
// RACSubject : 底层实现跟RACSignal不一样
    1、调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    2、调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock
 */
    
//    1、创建信号
    RACSubject *subject = [RACSubject subject];

//    2、订阅信号
    [subject subscribeNext:^(id x) {
//        block调用时刻：当信号发出新值，就会调用
        NSLog(@"第一个订阅者：%@",x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者:%@",x);
    }];
    
//    3、发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    
    
    
//    RACRepalySubject使用步骤
/**

 1、创建信号 [RACReplaySubject subject] ,跟RACSignal不一样，创建信号时没有block
 2、可以先发送信号，再订阅信号，RACSubject不可以！！！
    *订阅信号 -(RACDisposable)subscribeNext:(void(^)(id x))nextBlock
    *发送信号 sendNext:(id)value
 
 RACReplaySubject：底层实现和RACSubject不一样
    1、调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock
    2、调用subscribeNext订阅信号，遍历所有保存的值，一个一个调用订阅者的nextBlock
 
 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，再订阅信号
 也就是先保存值，再订阅值
 
*/
    
    
//    1、创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject replaySubjectWithCapacity:2];
    
//    2、发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
//    3、订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者收到的数据%@",x);
    }];
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者收到的数据%@",x);
    }];
    
}

/**
 // 先订阅，后发送信号
 2016-08-29 16:18:23.154 RACDemo[5507:185680] 第一个订阅者收到的数据1
 2016-08-29 16:18:23.154 RACDemo[5507:185680] 第二个订阅者收到的数据1
 2016-08-29 16:18:23.154 RACDemo[5507:185680] 第一个订阅者收到的数据2
 2016-08-29 16:18:23.155 RACDemo[5507:185680] 第二个订阅者收到的数据2
 */


/**
// 先发送信号，再订阅
 2016-08-29 16:19:43.945 RACDemo[5641:186739] 第一个订阅者收到的数据1
 2016-08-29 16:19:43.945 RACDemo[5641:186739] 第一个订阅者收到的数据2
 2016-08-29 16:19:43.946 RACDemo[5641:186739] 第二个订阅者收到的数据1
 2016-08-29 16:19:43.946 RACDemo[5641:186739] 第二个订阅者收到的数据2
 */

#pragma mark - 元祖

- (void)RACSequenceDemo
{
//    1、遍历数组
    NSArray *array = @[@1,@2,@3];
    
//    1、把数组转换成集合RACSequence，array.rac_seuqence
//    2、把集合RACSequence转换RACSignal信号类，array.rac_sequence.signal
//    3、订阅信号，激活信号，会自动把集合中的所有值，遍历出来
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
//    2、遍历字典，遍历出来的键值会包装成RACTuple（元祖对象）
    NSDictionary *dic = @{@"name":@"wangtongke",@"age":@18};
    
    [dic.rac_sequence.signal subscribeNext:^(id x) {
        
//        遍历字典  X为RAC的元祖（RACTuple）
//        解包元祖，会把元祖的值，按顺序给参数里边的变量赋值
        
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
//        以上 相当于一下写法
//        NSString *key1 = x[0];
//        NSString *value1 = x[1];
        
        NSLog(@"%@  %@\n",key,value);
        
    }];
    
}


#pragma mark - RACComand
-(void)RACCommandDemo
{
/**
 1、创建命令 initWithSignalblock:(RACSignal * (^)(id input))signalBlock
 2、在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
 3、执行命令 -(RACSignal *)execute:(id)input
 
// 注意事项
 1、signalBlock必须要返回一个signal，不能返回nil，
 2、如果不想要传递信号,直接创建空的信号返回[RACSignal empty]；
 3、RACCommand，如果数据传递完毕，必须调用[subscriber sendCompleted],这时命令才会执行完毕，否则永远处于执行中.
 4、RACComand需要被强引用，否则接手不到RACCommand中的信号，因此，RACCommand中的信号是延迟发送的。
 
 
// 设计思想  ： 内部signalBlock为什么要返回一直信号，这个信号有什么用
 1、在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
 2、当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了
 
 
// 如何拿到RACCommand中返回信号发出的数据
 1、RACCommand有个执行信号源executionSignal,这个signal of signal（信号的信号）,意思是发出的数据是信号，不是普通的类型
 2、订阅executionSignal就能拿到RACCommand中返回的信号，然后订阅signalblock返回的信号。
 
 
// 监听当前命令是否正在执行executing
 
// 使用场景  按钮点击，网络请求
 
 */
    
    
    
    
//  *******  1、创建命令
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令");
        NSLog(@"input---%@",input);
//        创建空信号，必须返回信号
//        return [RACSignal empty];
        
//  *******  2、创建信号，用来传递数据
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            [subscriber sendNext:@"请求数据"];
            
//            注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
//    强引用命令，不然会自动销毁，接受不到数据
    _command    = command;
    
//  *******  3、订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    
//    高级用法
//    switchToLatest:用于signal of signals，获取signal of signals 发出的最新的信号，也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"高级--%@",x);
    }];
    
//  ******** 4、监听命令是否执行完毕，默认会来一次，可以直接跳过，skip表示跳过第一次信号
    [[command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES)
        {
//            正在执行
            NSLog(@"正在执行");
        }
        else
        {
//            执行完成
            NSLog(@"执行完成");
        }
    }];
    
    
//   ********  5、执行命令
    [self.command execute:@1];
}

#pragma mark - RACMulticastConnection
- (void)RACMulticastConnectionDemo
{
/**
    RACMulticastConnection使用步骤
 
 ****   1、创建信号 +(RACSignal)createSignal
 ****   2、创建连接  RACMulticastConnection *connect = [signal publish];
 ****   3、订阅信号，注意：订阅的不再是之前的信号，而是连接的信号[connect.signal subscribeNext];
 ****   4、连接 [connect connect];
 

 RACMulticastConnection底层原理
 
 // 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
 // 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
 // 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
 // 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
 // 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
 // 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
 // 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock

 
 
 需求 ： 假设子啊一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
 解决  使用RACMulticastConnection。
 
 
 */
    
    
//  **********  1、创建请求信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求111111");
        [subscriber sendNext:@1];
        return nil;
    }];
    
    
//  **********  2、订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"接受数据11111--%@",x);
    }];
//    订阅两次信号
    [signal subscribeNext:^(id x) {
        NSLog(@"接受数据11111---%@",x);
    }];
    
//    会执行两次发送请求。也就是每订阅一次  就会发送一次请求
    
    
//    RACMulicastConnection解决重复请求问题
//  ********** 1、创建信号
    
    RACSignal *signal2  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        NSLog(@"发送请求2");
        [subscriber sendNext:@1];
    
        return nil;
    }];
//  ********** 2、 创建连接
    RACMulticastConnection *connect = [signal2 publish];
    
//  **********  3、订阅信号
//    注意：订阅信号也不能激活信号，只是保存订阅者到数据，必须通过连接，当调用连接，就会一次清调用所有订阅者的sendNext；
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者一信号");
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者二信号");
    }];
    
// **********  4、连接
    [connect connect];
    
}

#pragma mark - 常见用法
- (void)RACMethod
{
// ********************** 1、代替代理      **************************
    
/**
 需求： 自定义redView，监听redView中按钮点击
 之前都是需要通过代理监听，给红色view添加一个代理属性，点击按钮的时候，通知代理做事情
 rac_signalForSelector:把调用某个对象的方法的信息转换成信号，只要调用这个方法，就会发送信号
 这里表示只要redView调用btnClick，就会发出信号，只需要订阅就可以了
 
 */
    WTKView *view = [[WTKView alloc]initWithFrame:CGRectMake(0, 200, 375, 200)];
    [self.view addSubview:view];
    
    [[view rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮---%@",x);

//        怎么传值？？？？
        
    }];
    
    
    
// ********************** 2、KVO      **************************
    [[view rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    view.center = CGPointMake(100, 100);

    
    
// ********************** 3、监听事件      **************************
    UIButton *btn           = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor     = [UIColor purpleColor];
    btn.frame               = CGRectMake(300, 300, 200, 30);
    [btn setTitle:@"RAC" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮被点击了");
    }];
    
    
// ********************** 4、代替通知      **************************
//    把监听到的通知，转换成信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    
// ********************** 5、监听文本框文字改变      **************************
    
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"文字改变了---%@",x);
    }];
    
    
// ********************** 6、处理多个请求，都返回结果的时候，统一做处理      **************************
    
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        [subscriber sendNext:@"发送请求1"];
        
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"发送请求2"];
        });
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
//    使用注意：几个信号，参数一的方法就必须有几个参数，每个参数对应信号发出的数据
    [self rac_liftSelector:@selector(wtkUpdateWithDic1:withDic2:) withSignalsFromArray:@[request1,request2]];
}

- (void)wtkUpdateWithDic1:(id )dic1 withDic2:(id )dic2
{
    NSLog(@"1--%@\n 2---%@",dic1,dic2);
}


#pragma mark - RAC常见宏

- (void)RACHong
{
//    RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
    RAC(self.label,text) = _textField.rac_textSignal;
    
    
    
//  RACObserve(self, name):监听某个对象的某个属性,返回的是信号
    
    [RACObserve(self.label, text) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
//    @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。
//    最新版库名 已换成  EXTScope
    //    两个配套使用，先weak再strong
    @weakify(self);
//    @strongify(self);
    [RACObserve(self, label.text) subscribeNext:^(id x) {
        @strongify(self);
    }];

    
//    RACTuplePack：把数据包装成RACTuple（元组类）
//    把参数中的数据包装成元祖
    RACTuple *tuple = RACTuplePack(@10,@20);
    
    
//    RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。
//    把参数再用的数据包装成元祖
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
