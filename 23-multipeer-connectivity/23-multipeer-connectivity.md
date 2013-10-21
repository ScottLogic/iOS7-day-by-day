# iOS7 Day-by-Day: Day 23
## Multipeer Connectivity

### Introduction

One of the entirely new frameworks which was introduced in iOS7 was
MultipeerConnectivity. This represents a very 'Apple' approach to what is
traditionally a difficult problem: given that mobile devices all have multiple
different radio technologies built in to them, surely they should be able to
communicate with each other without having to send data via the internet. In the
past it would have been possible to create an ad-hoc wifi network, or pair
devices over bluetooth, but neither of these options has presented a very
user-friendly approach. With the MultipeerConnectivity framework this changes -
the mechanics of setting up networks is abstracted away from both the user and
the developer, and instead communication takes place via a technology-agnostic
API.

In reality the framework whatever technology it has available - whether it be
bluetooth, or wifi, either using an infrastructure network, or ad-hoc networking
if the devices don't share the same network. This is truly brilliant - the user
just gets to select which of the surrounding devices it wishes to connect to and
the framework will handle all the rest. It is even capable of using a node as a
router between 2 nodes which can't see each other in a mesh-network manner.

In today's post we'll run through the code that's needed to set up a multipeer
network like this, and how to send data between devices.

### Browsing for devices

In order to send data, it's necessary to establish a connection between devices,
which is done with one device 'browsing' for appropriate devices within range.
A request can then be sent to one of these devices, which will alert the user -
allowing them to accept or reject the connection. If the connection is accepted
then the framework will establish the link and allow data to be transferred.

There are 2 ways to browse for local devices - a visual one, and a programmatic
version. We're only going to look at the visual approach.

All nodes in the multipeer network have to have an ID - which is represented by 
the `MCPeerID` class:

    _peerID = [[MCPeerID alloc] initWithDisplayName:self.peerNameTextField.text];

Here we're allowing the user to enter a name which will be used to identify their
device to users they attempt to collect to.

The `MCSession` object is used to coordinate sending data between peers within
that session. We firstly create one and then add peers to it:

    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;

`MCSession` has a delegate property which adopts the `MCSessionDelegate` protocol.
This includes methods for monitoring as peers change state (e.g. disconnect), 
along with methods which are called when a peer in the network initiates a data
transfer.

In order to add peers to the session there is a `ViewController` subclass which
presents a list of local devices to the user and allows them to select which
they would like to establish a connection with. We create one of these and then
present it as a modal view controller:

    MCBrowserViewController *browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"shinobi-stream" session:_session];
    browserVC.delegate = self;
    [self presentViewController:browserVC animated:YES completion:NULL];

The `serviceType` argument is a string which represents the service we're trying
to connect to. This string can comprise of lowercase characters, numbers and hyphens,
and should be of a bonjour-like domain.

We're again assigning `self` to the `delegate` property - this time adopting the
`MCBrowserViewControllerDelegate` protocol. There are two methods we need to
implement - for completion and cancellation of the browser view controller. Here
we're going to dismiss the browser and enable a button if we were successful:

    #pragma mark - MCBrowserViewControllerDelegate methods
    - (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
    {
        [browserViewController dismissViewControllerAnimated:YES completion:NULL];
    }

    - (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
    {
        [browserViewController dismissViewControllerAnimated:YES completion:^{
            self.takePhotoButton.enabled = YES;
        }];
    }

If we run the app up at this point we'll be able to input a peer name, and then
bring up the browser to search for other devices. At this stage we don't haven't
implemented the advertising functionality for other devices, so we can't connect
to anything. We'll implement this in the next section, the pictures below show
the connection process if we do have a device to connect to, and the connection
is accepted:

![browse1](img/multipeer-browse1.png)
![browse2](img/multipeer-browse2.png)
![browse3](img/multipeer-browse3.png)


### Advertising availability

Advertising availability is made possible through the `MCAdvertiserAssistant`
class, which is responsible both for managing the network layer, and also presenting
an alert to the user to allow them to accept or reject an incoming connection.

In the same way that we needed a session and peer ID to browse, we need them for
advertising, so again we allow the user to specify a string to be used as a peer
name:

    _peerID = [[MCPeerID alloc] initWithDisplayName:self.peerNameTextField.text];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
    _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"shinobi-stream" discoveryInfo:nil session:_session];

We're using the same string for the `serviceType` parameter as we did within the
browser - this will enable the connections to be matched appropriately.

Finally we need to start advertising our availability:

    [_advertiserAssistant start];

If we now fire up the browser on one device, and the advertiser on another then
they should be able to find each other. When the device appears in the browser,
and the user taps on it, then the user with the advertising device will be
presented with an alert allowing them to choose whether or not to make the 
connection:

![permission](img/multipeer-permission.png)


### Sending Data

There are 3 ways in which data can be transferred over the multipeer network
we've established - an `NSData` object, an `NSStream` or sending a file-based
resource. All three of these share a common paradigm - the `MCSession` object
has methods to initiate each of these transfers, and then the session at the 
receiving end will call the appropriate delegate method.

For example, we're going to take a photo with one device and then have it
automagically appear on the screen of the other device. We'll use the `NSData`
approach for this example, but the methodology is very similar for each of them.

We use `UIImagePickerController` to take a simple photo

    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];

And implement the following delegate method to get the photo out as expected:

    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        UIImage *photo = info[UIImagePickerControllerOriginalImage];
        UIImage *smallerPhoto = [self rescaleImage:photo toSize:CGSizeMake(800, 600)];
        NSData *jpeg = UIImageJPEGRepresentation(smallerPhoto, 0.2);
        [self dismissViewControllerAnimated:YES completion:^{
            NSError *error = nil;
            [_session sendData:jpeg toPeers:[_session connectedPeers] withMode:MCSessionSendDataReliable error:&error];
        }];
    }

The line of interest here is the call to `sendData:toPeers:withMode:error:` on
the `MCSession` object. This can take an `NSData` object and send it to other
peers in the network. Here we're selecting to send it to all the peers in the
network. The mode allows you to select whether or not you want the data transferred
reliably or not. If you select reliable then the messages will definitely arrive
and will be in the correct order, but will have a higher time overhead. Using
the unreliable mode means that some messages may be lost, but the delay will be 
much smaller.

To receive the data on the other device we just provide an appropriate
implementation for the correct delegate method:

    - (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
    {
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
        self.imageView.contentScaleFactor = UIViewContentModeScaleAspectFill;
    }

Here we're simply creating a `UIImage` from the `NSData` object, and then setting
it as the image for on a `UIImageView`. The following pictures show the photo
being taken on one device, and then displayed on another:

![Sending](img/multipeer-sending.png)
![Received](img/multipeer-received.png)

The streaming and resource APIs work in much the same way, although the resource
API provides asynchronous progress updates, and is hence more suitable for large
data transfers.

### Conclusion

The MultipeerConnectivity framework is incredibly powerful, and Apple-like in its
concept of abstracting the fiddly technical details away from the developer. It's
pretty obvious that the new AirDrop functionality which appeared in iOS7 is built
on top of this framework, and that's very much the tip of the iceberg in terms of
what could be built using this framework. Imagine an iBeacon which, when you're
near it, not only notifies you of the fact, but then sends you information without
using the internet. Maybe you could have multi-angle video streamed to your device
at a sports event, but only if you're in the venue? I can't wait to see what people
build!

