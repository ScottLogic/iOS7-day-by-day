# iOS7 Day-by-Day: Day 17
## iBeacons


### Introduction

Although not really mentioned in any great detail during the iOS7 unveiling
keynote, a major addition is the concept of 'iBeacons'. These are a new feature
of Bluetooth LE which allows proximity-based notifications and ranging. Sample
uses include notification that you're approaching a shop, and then showing a list
of special offers. Or maybe bringing up the receipt for an order you have purchased
as you approach the cash register. There is a long list of different possible uses,
and I'm sure we'll see some further creative uses over the coming months.

Today we're going to take a look at how to get an iOS device to acts as an
iBeacon, and also how to use a different device to estimate the distance to that
iBeacon. We'll create an app based on a "Hot/Cold" hide and seek game, where the
iBeacon device can be hidden, and the seeker device displays updates of estimated
range to it.


### Create a beacon

To make an app act like an iBeacon we use CoreLocation to create the beacon
properties, and then ask CoreBluetooth to broadcast them appropriately.

iBeacons have several properties used to identify it uniquely.

- `proximityUUID`. This is a `NSUUID` object which identifies your company's
beacons. You can have may beacons with the same uuid, and set CoreLocation to
notify you whenever one comes into range.
- `major`. An `NSNumber` representing the major ID of this particular beacon.
This could identify a particular store, or floor within a store. The number is
represented as a 16-bit unsigned integer.
- `minor`. Another `NSNumber` which represents the individual beacon.

It's possible to set CoreLocation to notify at any of the 3 possible granularities
of iBeacon ID - i.e. notify whenever any iBeacon with the same UUID is in range,
or with the same UUID and `major` ID, or require a specific beacon - with uuid,
`major` and `minor` ids all matching.

We need to include both CoreLocation and CoreBluetooth for this project:

    @import CoreBluetooth;
    @import CoreLocation;

In order to make an app appear as a beacon, we create a `CLBeaconRegion` object,
specifying IDs we require. In our case we will only set the UUID:

    _rangedRegion = [[CLBeaconRegion alloc] initWithProximityUUID:_beaconUUID
                                                       identifier:@"com.shinobicontrols.HotOrCold"];

The UUID was created as per:

    _beaconUUID = [[NSUUID alloc] initWithUUIDString:@"3B2DCB64-A300-4F62-8A11-F6E7A06E4BC0"];

We can create a `UUIDString` using the OSX `uuidgen` tool:

    ➜  17-ibeacons git:(days/17-ibeacons) ✗ uuidgen
    874D949F-3325-4B3F-A6F4-AB5BBCE440F6

We'll also need to create a CoreBluetooth peripheral manager:

    _cbPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                   queue:dispatch_get_main_queue()];

A `CBPeripheralManager` has to have a delegate set (even though we won't be using
it in this example), and it has a required method:

    #pragma mark - CBPeripheralManager delegate methods
    - (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
    {
        // We don't really care...
    }

Now, when we want to start broadcasting as an iBeacon then we get hold of a
dictionary of settings from the `CLBeaconRegion` and pass it to the
`CBPeripheralManager` to begin broadcast:

    - (IBAction)handleHidingButtonPressed:(id)sender {
        if(_cbPeripheralManager.state < CBPeripheralManagerStatePoweredOn) {
            NSLog(@"Bluetooth must be enabled in order to act as an iBeacon");
            return;
        }
        
        // Now we construct a CLBeaconRegion to represent ourself
        NSDictionary *toBroadcast = [_rangedRegion peripheralDataWithMeasuredPower:@-60];
        
        [_cbPeripheralManager startAdvertising:toBroadcast];
    }

Firstly we check that the peripheral manager is ready to go, before constructing
the settings to broadcast, and then beginning to advertise the details. The
`measuredPower` argument specifies the power in dBs observed at a distance of 1m
from the transmitter.

![Hiding](img/ibeacons-hiding.png)

We can stop the iBeacon by calling the `stopAdvertising` method on the
`CBPeripheralManager` object.


### Beacon Ranging

Using CoreLocation, we can request alerts when an iBeacon with a particular ID
comes into range, or get regular updates as to the approximate range of all
local beacons. In our 'HotOrCold' game we are going to request range updates
for the beacon we created above.

We need to create a CoreLocation `CLLocationManager`:

    _clLocationManager = [CLLocationManager new];
    _clLocationManager.delegate = self;

Notice that we're setting the delegate as well, and we'll implement the following
delegate method:

    - (void)locationManager:(CLLocationManager *)manager
            didRangeBeacons:(NSArray *)beacons
                   inRegion:(CLBeaconRegion *)region
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

This delegate method responds to ranging updates from beacons (we'll register
to receive these in a moment). The delegate method gets called at a frequency of
`1 Hz`, and is provided with an array of beacons. A `CLBeacon` has properties
which determine its identity, and also the approximate range of the beacon. We're
using this to set the background color of the view and update the status label
using the following utility method:

    - (void)setStatus:(NSString *)status
    {
        self.statusLabel.hidden = NO;
        self.statusLabel.text = status;
    }

In order for this delegate method to be called, we need ask the location manager
to start 'ranging' for a particular beacon:

    [_clLocationManager startRangingBeaconsInRegion:_rangedRegion];

This has a complimentary method to stop the beacon ranging: 

    [_clLocationManager stopRangingBeaconsInRegion:_rangedRegion];

If you run up this app on 2 devices (both of which have Bluetooth LE) and set
one to hide and one to seek you can play "HotOrCold" yourself:

![Freezing](img/ibeacons-freezing.png)
![Warmer](img/ibeacons-warmer.png)
![Hot](img/ibeacons-hot.png)

### Conclusion

iBeacons offer fantastic potential - they could even be one of the most disruptive
new features of iOS7. I think they are both Apple's answer to, and the final nail
in the coffin, of NFC on mobile devices. Hopefully not only will our phones soon
have the correct information available to us as we arrive at a service desk, but
we might also start to see indoor navigation. I encourage you to take a look at
the iBeacon API - it's not very complicated, and I look forward to seeing your
innovative uses!


