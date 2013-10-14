/*
 Copyright 2013 Scott Logic Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


#import "SCViewController.h"
@import CoreBluetooth;
@import CoreLocation;

@interface SCViewController () <CBPeripheralManagerDelegate, CLLocationManagerDelegate> {
    CBPeripheralManager *_cbPeripheralManager;
    NSUUID *_beaconUUID;
    CLBeaconRegion *_rangedRegion;
    CLLocationManager *_clLocationManager;
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
    self.signalStrengthLabel.text = @"";
    // And create a UUID
    _beaconUUID = [[NSUUID alloc] initWithUUIDString:@"3B2DCB64-A300-4F62-8A11-F6E7A06E4BC0"];
    _cbPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    _clLocationManager = [CLLocationManager new];
    _clLocationManager.delegate = self;
    _rangedRegion = [[CLBeaconRegion alloc] initWithProximityUUID:_beaconUUID identifier:@"com.shinobicontrols.HotOrCold"];
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
    NSDictionary *toBroadcast = [_rangedRegion peripheralDataWithMeasuredPower:@-60];
    
    [_cbPeripheralManager startAdvertising:toBroadcast];
    
    [self setStatus:@"hiding..."];
    [self setProcessActive:YES];
}

- (IBAction)handleSeekingButtonPressed:(id)sender {
    [self setProcessActive:YES];
    
    [_clLocationManager startRangingBeaconsInRegion:_rangedRegion];
    
    
}

- (IBAction)handleStopButtonPressed:(id)sender {
    if (_cbPeripheralManager) {
        [_cbPeripheralManager stopAdvertising];
    }
    [_clLocationManager stopRangingBeaconsInRegion:_rangedRegion];
    [self setStatus:@""];
    [self setProcessActive:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.statusLabel.textColor = [UIColor blackColor];
    self.signalStrengthLabel.text = @"";
}

#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if([region isEqual:_rangedRegion]) {
        // Let's just take the first beacon
        CLBeacon *beacon = [beacons firstObject];
        self.statusLabel.textColor = [UIColor whiteColor];
        self.signalStrengthLabel.textColor = [UIColor whiteColor];
        self.signalStrengthLabel.text = [NSString stringWithFormat:@"%ddB", beacon.rssi];
        switch (beacon.proximity) {
            case CLProximityUnknown:
                self.view.backgroundColor = [UIColor blueColor];
                [self setStatus:@"Freezing!"];
                break;
                
            case CLProximityFar:
                self.view.backgroundColor = [UIColor blueColor];
                [self setStatus:@"Cold!"];
                break;
                
            case CLProximityImmediate:
                self.view.backgroundColor = [UIColor purpleColor];
                [self setStatus:@"Warmer"];
                break;
                
            case CLProximityNear:
                self.view.backgroundColor = [UIColor redColor];
                [self setStatus:@"HOT!"];
                break;
                
            default:
                break;
        }
    }
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
