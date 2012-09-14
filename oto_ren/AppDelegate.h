//
//  AppDelegate.h
//  oto_ren
//
//  Created by zaziko on 2012/09/14.
//  Copyright (c) 2012年 zaziko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//コアデータ
@property(nonatomic,retain,readonly)
    NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain,readonly)
    NSManagedObjectModel *managedObjectModel;
@property(nonatomic,retain,readonly)
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) ViewController *viewController;


//ファイルに保存
-(void)saveContext;
//ディレクトリを取得
-(NSURL *)applicationDocumentsDirectory;

@end