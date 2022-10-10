//
//  AppDelegate.m
//  BluetoothKeeper
//
//  Created by 东升 on 2022/10/10.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSString *soundFile;
@property (nonatomic, strong) NSURL *file;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    _soundFile = [[NSBundle mainBundle] pathForResource:@"poop" ofType:@"mp3"];

    _file = [NSURL fileURLWithPath:_soundFile];

    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_file error:nil];
    _player.volume = 0.001;

    [_player prepareToPlay];

    [_player play];

    [self addStatusItem];

    __weak AppDelegate *weakSelf = self;

    _timer = [NSTimer timerWithTimeInterval:239 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf.player play];
    }];

    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)addStatusItem {


    NSStatusBar *systemStatusBar = [NSStatusBar systemStatusBar];
    NSStatusItem *statusItem = [systemStatusBar statusItemWithLength:NSSquareStatusItemLength];

    self.statusItem = statusItem;
    self.statusItem.button.image = [NSImage imageNamed:@"status_bar_icon"];
    self.statusItem.button.toolTip = @"我就是一个无情的发声器";

    NSMenu *mainMenu = [[NSMenu alloc] initWithTitle:@"退出"];

    [mainMenu addItemWithTitle:@"退出" action:@selector(quit:) keyEquivalent:@"Q"];

    self.statusItem.menu = mainMenu;

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - Private Methods
- (void)quit:(NSStatusItem *)item {
    [self.timer invalidate];
    self.timer = nil;
    [[NSApplication sharedApplication] terminate:nil];
}

@end
