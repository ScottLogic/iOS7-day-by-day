//
//  SCViewController.m
//  HotOrCold
//
//  Created by Sam Davies on 12/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"
@import CoreBluetooth;
@import CoreLocation;

@interface SCViewController () <CBPeripheralManagerDelegate> {
    CBPeripheralManager *_cbPeripheralManager;
    NSUUID *_beaconUUID;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set current state
    [self setStatus:@""];
    [self setProcessActive:NO];
    // And create a UUID
    _beaconUUID = [[NSUUID alloc] initWithUUIDString:@"3B2DCB64-A300-4F62-8A11-F6E7A06E4BC0"];
    _cbPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Button handling methods
- (IBAction)handleHidingButtonPressed:(id)sender {
    if(_cbPeripheralManager.state < CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Bluetooth must be enabled in order to act as an iBeacon");
        return;
    }
    
    // Now we construct a CLBeaconRegion to represent ourself
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_beaconUUID
                                            identifier:@"com.shinobicontrols.HotOrCold"];
    NSDictionary *toBroadcast = [region peripheralDataWithMeasuredPower:@-60];
    
    [_cbPeripheralManager startAdvertising:toBroadcast];
    
    [self setStatus:@"hiding..."];
    [self setProcessActive:YES];
}

- (IBAction)handleStopButtonPressed:(id)sender {
    if (_cbPeripheralManager) {
        [_cbPeripheralManager stopAdvertising];
    }
    [self setStatus:@""];
    [self setProcessActive:NO];
}

- (IBAction)handleSeekingButtonPressed:(id)sender {
}

#pragma mark - CBPeripheralManager delegate methods
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // We don't really care...
}

#pragma mark - Utility methods
- (void)setStatus:(NSString *)status
{
    self.statusLabel.hidden = NO;
    self.statusLabel.text = status;
}

- (void)setProcessActive:(BOOL)active
{
    // If active then hide the go buttons
    [self.goButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setHidden:active];
    }];
    // If active then we need the stop button
    self.stopButton.hidden = !active;
}
@end
