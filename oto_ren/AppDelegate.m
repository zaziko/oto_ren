//
//  AppDelegate.m
//  oto_ren
//
//  Created by zaziko on 2012/09/14.
//  Copyright (c) 2012年 zaziko. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate
//Coredata関連
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)saveContext
{
    NSError *error=nil;
    NSManagedObjectContext *managedObjectContext=self.managedObjectContext;
    if (managedObjectContext !=nil)
    {
        //エラーじゃなかったり変更があれば書き込む
        if ([managedObjectContext hasChanges]&&![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@,%@",error,[error userInfo]);
            abort();
        }
    }
}


-(NSManagedObjectContext *)managedObjectContext
{
    //インスタンスが作成済みならそれを返す
    if (__managedObjectContext !=nil)
    {
        return __managedObjectContext;
    }
    
    //シリアライズの情報を取得
    NSPersistentStoreCoordinator *cordinator=[self persistentStoreCoordinator];
    
    if (cordinator !=nil)
    {
        __managedObjectContext=[[NSManagedObjectContext alloc]init];
        [__managedObjectContext setPersistentStoreCoordinator:cordinator];
    }
    return __managedObjectContext;
}


-(NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel !=nil)
    {
        return __managedObjectModel;
    }
    
    NSURL *modelURL=[[NSBundle mainBundle]URLForResource:@"Voice"
                                           withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    
    
    return __managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{

    if (__persistentStoreCoordinator !=nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL=[[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"Voice.sqlite"];
    
    NSError *error=nil;
    __persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:nil
                                                            error:&error])
    {
        NSLog(@"unresolved error %@,%@",error,[error userInfo] );
        abort();
    }
    
    return __persistentStoreCoordinator;
}

-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
                     inDomains:NSUserDomainMask]lastObject];

}
@end
