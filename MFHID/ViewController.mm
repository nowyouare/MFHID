//
//  ViewController.m
//  MFHID
//
//  Created by Terry Lewis on 9/1/17.
//  Copyright © 2017 Terry Lewis. All rights reserved.
//

#import "ViewController.h"
#import <GameController/GameController.h>
#import "HIDController.h"

@interface GCController (Private)

+ (void)_startWirelessControllerDiscoveryWithCompanions:(BOOL)withCompanions btClassic:(BOOL)btClassic btle:(BOOL)btle completionHandler:(nullable void (^)(void))completionHandler;
    
@end

@implementation ViewController{
    GCExtendedGamepad *_gamepad;
    HIDController *_hidController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchForControllersIndicator.hidden = YES;
    
    [self.searchForControllersButton setTarget:self];
    [self.searchForControllersButton setAction:@selector(searchForControllersButtonClicked:)];
    
    self.connectControllerButton.target = self;
    self.connectControllerButton.action = @selector(connectControllerButtonClicked:);
    
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear{
    [super viewDidAppear];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self connectControllerButtonClicked:self];
    });
}

- (void)dealloc{
    delete _hidController;
}

- (void)searchForControllersButtonClicked:(id)sender{
    NSLog(@"Searching for controllers...");
    NSLog(@"Have: %@", [GCController controllers]);
    self.searchForControllersIndicator.hidden = NO;
    [self.searchForControllersIndicator startAnimation:self];
    [GCController _startWirelessControllerDiscoveryWithCompanions:NO btClassic:NO btle:NO completionHandler:^{
        NSLog(@"Controllers: %@", GCController.controllers);
    }];
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        NSLog(@"Controllers: %@", GCController.controllers);
        self.searchForControllersIndicator.hidden = YES;
        [self.searchForControllersIndicator stopAnimation:self];
    }];
}

- (void)connectControllerButtonClicked:(id)sender{
    NSArray<GCController *> *controllers = [GCController controllers];
    if (controllers.count > 0) {
        GCController *controller = [controllers firstObject];
        _gamepad = controller.extendedGamepad;
        NSLog(@"Gamepad: %@", _gamepad);
        [self configureGamepad];
    }else{
        NSLog(@"No gamepads found.");
    }
}

- (void)configureGamepad{
    if (_hidController != NULL){
        delete _hidController;
    }

    _hidController = new HIDController();



    [_gamepad setValueChangedHandler:^(GCExtendedGamepad *gamepad, GCControllerElement *element){
        NSLog(@"%@", element);
    }];

    // Buttons
    [_gamepad.buttonA setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setButtonAPressed(pressed);
    }];

    [_gamepad.buttonB setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setButtonBPressed(pressed);
    }];

    [_gamepad.buttonX setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setButtonXPressed(pressed);
    }];

    [_gamepad.buttonY setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setButtonYPressed(pressed);
    }];

    // Directional-pad.
    [_gamepad.dpad.up setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setDpadUpPressed(pressed);
    }];

    [_gamepad.dpad.right setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setButtonAPressed(pressed);
    }];

    [_gamepad.dpad.down setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setButtonAPressed(pressed);
    }];

    [_gamepad.dpad.left setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setButtonAPressed(pressed);
    }];


    // Shoulder buttons.
    [_gamepad.leftShoulder setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setLeftShoulderPressed(pressed);
    }];

    [_gamepad.rightShoulder setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setRightShoulderPressed(pressed);
    }];

    // Triggers.
    [_gamepad.leftTrigger setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setLeftTriggerPressed(pressed);
    }];

    [_gamepad.rightTrigger setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        _hidController->setRightTriggerPressed(pressed);
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end