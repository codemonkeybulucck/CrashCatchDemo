//
//  AppDelegate.m
//  CollectionCrashInfoDemo
//
//  Created by lemon on 2018/8/22.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import "AppDelegate.h"
#include <execinfo.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self startListenException];
    return YES;
}

- (void)startListenException{
    //捕捉crash类型的错误
    NSSetUncaughtExceptionHandler(&CrashExceptionHandler);
    
    //捕捉sinal类型的错误
    signal(SIGABRT, SignalExceptionHandler);
    signal(SIGILL, SignalExceptionHandler);
    signal(SIGSEGV, SignalExceptionHandler);
    signal(SIGFPE, SignalExceptionHandler);
    signal(SIGBUS, SignalExceptionHandler);
    signal(SIGPIPE, SignalExceptionHandler);
}


#pragma mark - 处理异常
void CrashExceptionHandler(NSException *exception){
    NSArray *callStack = [exception callStackSymbols];
    NSString *reson = [exception reason];
    NSString *name = [exception name];
    NSLog(@"名字：%@ \n原因：%@\n exception捕获崩溃，堆栈信息：%@ \n",name,reson,callStack);
    //TODO:上传Exception信息
    
}

void SignalExceptionHandler(int signal){
    NSArray *callStack = [AppDelegate backtrace];
    NSString *name = @"LMSignalException";
    NSString *reson = [NSString stringWithFormat:@"signal %d was raised",signal];
    NSLog(@"名字：%@ \n原因：%@\n信号捕获崩溃，堆栈信息：%@ \n",name,reson,callStack);

    //TODO:上传Exception信息
}

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = 0; i < frames; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
