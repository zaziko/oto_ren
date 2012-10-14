//
//  ViewController.m
//  oto_ren
//
//  Created by zaziko on 2012/09/14.
//  Copyright (c) 2012年 zaziko. All rights reserved.
//

#import "ViewController.h"
#import <CoreAudio/CoreAudioTypes.h>

//とりあえず10秒にしておく
static const NSTimeInterval kMaxRecordTime=10;

//これなんじゃろ
@interface ViewController ()

@end


//
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}



//ここから各ボタンの機能
//レコード機能
- (IBAction)pushRecButton:(id)sender
{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    if (!session.inputIsAvailable)
    {
        return;
    }
    
    [self.recordButton setEnabled:NO];
    
    [self.player stop];
    [self setPlayer:nil];
    
    NSURL *fileURL=self.soundFileURL;
    
    if(!fileURL)
    {
        fileURL=[self newFileURL];
        [self setSoundFileURL:fileURL];
    }
     
    
    [session setCategory:AVAudioSessionCategoryRecord error:NULL];
    
    double sampleRate=session.preferredHardwareSampleRate;
    NSInteger channel=session.currentHardwareInputNumberOfChannels;
    
    NSDictionary *dict=
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithInteger:kAudioFormatLinearPCM],AVFormatIDKey,
     [NSNumber numberWithDouble:sampleRate],AVSampleRateKey,
     [NSNumber numberWithInteger:channel],AVNumberOfChannelsKey,
     [NSNumber numberWithInteger:16],AVLinearPCMBitDepthKey, nil];
    
    AVAudioRecorder *recorder;
    recorder=[[AVAudioRecorder alloc]initWithURL:fileURL
                                        settings:dict
                                           error:NULL];
    [self setRecorder:recorder];
    [recorder setDelegate:self];
    
    [recorder recordForDuration:kMaxRecordTime];
    
    NSString *status=NSLocalizedString(@"＿φ(･ω･` )", @"");
    [self.statusLabel setText:status];
    
    [recorder release];
}

//録音が終わったら
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
    [self pushStopButton:nil];
}

//再生が終わったら
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                      successfully:(BOOL)flag
{
    [self pushStopButton:nil];
}

//サウンドファイルのURLを返す
-(NSURL *)soundFileURLWithName:(NSString *)fileName
{
    
    //ドキュメントフォルダのパスを取得
    NSArray *array;
    array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                              NSUserDomainMask,
                                              YES);
    
    //配列の最後の要素をdirへ。
    NSString *dir=[array lastObject];
    NSString *path=[dir stringByAppendingPathComponent:fileName];
    NSURL *fileURL=[NSURL fileURLWithPath:path];
    
    return fileURL;
}

-(NSURL *)newFileURL
{
    static BOOL sFirst=YES;
    
    if(sFirst)
    {
        srandomdev();
        sFirst=NO;
    }
    NSArray *array;
    array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *dir=[array lastObject];
    
    NSString *path=nil;
    
    while(!path)
    {
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
        long l=random();
        
        NSString *fileName;
        fileName=[NSString stringWithFormat:@"%lx.mov",l];
        
        NSString *tempPath;
        tempPath=[dir stringByAppendingPathComponent:fileName];
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:tempPath])
        {
            
            path=[tempPath copy];
        }
        [pool release];
    }
    
    NSURL *url=[NSURL fileURLWithPath:path];
    [path release];
    
    return url;
}
 

-(void)openSoundFile:(NSURL *)fileURL
{
    [self setPlayer:nil];
    
    AVAudioPlayer *player;
    player=[[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:NULL];
    
    [player setDelegate:self];
    [self setPlayer:player];
    
    AVAudioSession *session=[AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
    [session setActive:YES error:NULL];
    
    [player release];
}





//再生機能
- (IBAction)pushPlayButton:(id)sender
{
    AVAudioRecorder *recorder=self.recorder;
    NSString *status=nil;
    
    if(recorder)
    {
        if (recorder.recording)
        {
            [recorder pause];
            status=NSLocalizedString(@"Σ( °Д° )", @"");
        }
        
        else
        {
            NSTimeInterval t=kMaxRecordTime-recorder.currentTime;
            [recorder recordForDuration:t];
            status=NSLocalizedString(@"＿φ(･ω･` )", @"");
        }
    }
    
    else
    {
        AVAudioPlayer *player=self.player;
        if (player.playing)
        {
            [player pause];
            status=NSLocalizedString(@"Σ( °Д° )", @"");
        }
        else
        {
            [player play];
            status=NSLocalizedString(@"( `)3')▃▃▃▅▆▇▉", @"");
        }
    }
    [self.statusLabel setText:status];
}



//設定機能
- (IBAction)pushSettingButton:(id)sender
{

    //アラートを表示する
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"わっ！"
                                                 message:@"見てもいいけど\n(´･ε･`)\n何もないよ"
                                                delegate:self
                                       cancelButtonTitle:@"じゃあやめる"
                                       otherButtonTitles:@"見るだけみる", nil];
    [alert show];
    
    [alert release];

}

//アラートボタンが押されたら
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex)
    {
        case 0://じゃあやめる
        {
            break;
        }
        case 1://見る
        {
            settingViewController *settingVC;
            settingVC=[[settingViewController alloc]init];
            
            [self presentModalViewController:settingVC animated:YES];
            
            [settingVC release];
            break;
        }
    }
}



//停止ボタン
- (IBAction)pushStopButton:(id)sender
{
    AVAudioRecorder *recorder=self.recorder;
    
    if(recorder)
    {
        [recorder stop];
        [self setRecorder:nil];
        
        NSURL *url=self.soundFileURL;
        NSString *fileName;
        fileName=[[self.soundFileURL path]lastPathComponent];
        
        [self.managedObject setValue:fileName forKey:@"voice"];
        
        
     
        
        [self openSoundFile:url];
    }
    else
    {
        [self.player stop];
    }
    
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:NO error:NULL];
    
    [self.recordButton setEnabled:YES];
    
    NSString *status=NSLocalizedString(@"( ´･ω･` )", @"");
    [self.statusLabel setText:status];
}


@end
