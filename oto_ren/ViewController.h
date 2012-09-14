//
//  ViewController.h
//  oto_ren
//
//  Created by zaziko on 2012/09/14.
//  Copyright (c) 2012年 zaziko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CoreData/CoreData.h>
#import<AVFoundation/AVFoundation.h>
#import "settingViewController.h"

@interface ViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,
UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UINavigationController *_navigationController;
    NSManagedObject *_managedObject;
    NSURL *_soundFileURL;
    AVAudioPlayer *_player;
    AVAudioRecorder *_recorder;

}

//@property(retain,nonatomic)settingViewController *settingViewController;
@property(retain,nonatomic)UINavigationController *navigationController;

@property(retain,nonatomic) NSManagedObject *managedObject;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIButton *playPauseButton;
@property (retain, nonatomic) IBOutlet UIButton *recordButton;

@property(retain,nonatomic)NSURL *soundFileURL;
@property(retain,nonatomic)AVAudioRecorder *recorder;
@property(retain,nonatomic)AVAudioPlayer *player;

- (IBAction)pushRecButton:(id)sender;
- (IBAction)pushPlayButton:(id)sender;
- (IBAction)pushSettingButton:(id)sender;
- (IBAction)pushStopButton:(id)sender;


@end
