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

#import "SCMasterViewController.h"
@import MultipeerConnectivity;

@interface SCMasterViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    MCPeerID *_peerID;
    MCSession *_session;
}

@end

@implementation SCMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)handleFindPeersButton:(id)sender {
    [self.peerNameTextField resignFirstResponder];
    if([self.peerNameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Peer name" message:@"You must specify a peer name to browse." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } else {
        _peerID = [[MCPeerID alloc] initWithDisplayName:self.peerNameTextField.text];
        _session = [[MCSession alloc] initWithPeer:_peerID];
        _session.delegate = self;
        MCBrowserViewController *browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"shinobi-stream" session:_session];
        browserVC.delegate = self;
        [self presentViewController:browserVC animated:YES completion:NULL];
    }
}

- (IBAction)handleTakePhotoButtonPressed:(id)sender {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate methods
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

#pragma mark - MCSessionDelegate methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

#pragma mark - utility methods
- (UIImage*)rescaleImage:(UIImage*)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
