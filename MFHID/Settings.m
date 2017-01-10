//
// Created by Terry Lewis on 10/1/17.
// Copyright (c) 2017 Terry Lewis. All rights reserved.
//

#import "Settings.h"
#import "StatusBarManager.h"

static NSString *kShowDevicesWindowOnStartSettingsKey = @"ShowDevicesWindowOnStart";
static NSString *kShowStatusBarIconSettingsKey = @"ShowStatusBarIcon";
static NSString *kLeftStickDeadZoneXSettingsKey = @"LeftStickDeadZoneX";
static NSString *kLeftStickDeadZoneYSettingsKey = @"LeftStickDeadZoneY";
static NSString *kRightStickDeadZoneXSettingsKey = @"RightStickDeadZoneX";
static NSString *kRightStickDeadZoneYSettingsKey = @"RightStickDeadZoneY";

@implementation Settings {
    NSUserDefaults *_userDefaults;
}

+ (instancetype)sharedSettings {
    static Settings *sharedSettings = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
       sharedSettings = [[self alloc] init];
    });
    return sharedSettings;
}

- (instancetype)init{
    if (self = [super init]){
        _userDefaults = [NSUserDefaults standardUserDefaults];
        [self loadSettings];
    }
    return self;
}

- (BOOL)boolForSettingNamed:(NSString *)settingName defaultValue:(BOOL)defaultValue{
    id temp = [_userDefaults objectForKey:settingName];
    if (temp){
        return [temp boolValue];
    }
    return defaultValue;
}

- (float)floatForSettingNamed:(NSString *)settingName defaultValue:(float)defaultValue{
    id temp = [_userDefaults objectForKey:settingName];
    if (temp){
        return [temp floatValue];
    }
    return defaultValue;
}

- (void)loadSettings{
    _showDevicesWindowOnStart = [self boolForSettingNamed:kShowDevicesWindowOnStartSettingsKey defaultValue:YES];
    _showStatusBarIcon = [self boolForSettingNamed:kShowStatusBarIconSettingsKey defaultValue:YES];

    _leftStickDeadzoneX = [self floatForSettingNamed:kLeftStickDeadZoneXSettingsKey defaultValue:0.0f];
    _leftStickDeadzoneY = [self floatForSettingNamed:kLeftStickDeadZoneYSettingsKey defaultValue:0.0f];
    _rightStickDeadzoneX = [self floatForSettingNamed:kRightStickDeadZoneXSettingsKey defaultValue:0.0f];
    _rightStickDeadzoneY = [self floatForSettingNamed:kRightStickDeadZoneYSettingsKey defaultValue:0.0f];
}

- (void)setShowDevicesWindowOnStart:(BOOL)showDevicesWindowOnStart {
    _showDevicesWindowOnStart = showDevicesWindowOnStart;
    [_userDefaults setBool:self.showDevicesWindowOnStart forKey:kShowDevicesWindowOnStartSettingsKey];
}

- (void)setShowStatusBarIcon:(BOOL)showStatusBarIcon {
    _showStatusBarIcon = showStatusBarIcon;
    [_userDefaults setBool:self.showStatusBarIcon forKey:kShowStatusBarIconSettingsKey];
    StatusBarManager.sharedManager.statusBarEnabled = self.showStatusBarIcon;
}

- (void)setLeftStickDeadzoneX:(float)leftStickDeadzoneX {
    _leftStickDeadzoneX = leftStickDeadzoneX;
    [_userDefaults setFloat:self.leftStickDeadzoneX forKey:kLeftStickDeadZoneXSettingsKey];
}

- (void)setLeftStickDeadzoneY:(float)leftStickDeadzoneY {
    _leftStickDeadzoneY = leftStickDeadzoneY;
    [_userDefaults setFloat:self.leftStickDeadzoneY forKey:kLeftStickDeadZoneYSettingsKey];
}

- (void)setRightStickDeadzoneX:(float)rightStickDeadzoneX {
    _rightStickDeadzoneX = rightStickDeadzoneX;
    [_userDefaults setFloat:self.rightStickDeadzoneX forKey:kRightStickDeadZoneXSettingsKey];
}

- (void)setRightStickDeadzoneY:(float)rightStickDeadzoneY {
    _rightStickDeadzoneY = rightStickDeadzoneY;
    [_userDefaults setFloat:self.rightStickDeadzoneY forKey:kRightStickDeadZoneYSettingsKey];
}


@end