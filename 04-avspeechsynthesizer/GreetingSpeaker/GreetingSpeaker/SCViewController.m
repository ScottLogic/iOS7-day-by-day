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
#import "SCGreetingLanguage.h"
@import AVFoundation;

@interface SCViewController () <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *availableLanguages;
    AVSpeechSynthesizer *speechSynthesizer;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    availableLanguages = [SCGreetingLanguage listOfGreetings];
    
    // Join up the picker
    self.languagePicker.delegate = self;
    self.languagePicker.dataSource = self;
    self.greetingLabel.text = [[availableLanguages firstObject] greeting];
    
    // Create the speech synthesizer
    speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    
    NSLog(@"%@", [AVSpeechSynthesisVoice speechVoices]);
}

- (IBAction)greetingButtonPressed:(id)sender {
    SCGreetingLanguage *gl = availableLanguages[[self.languagePicker selectedRowInComponent:0]];
    [speechSynthesizer speakUtterance:[gl greetingUtterance]];
}




#pragma mark - UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [availableLanguages[row] name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.greetingLabel.text = [availableLanguages[row] greeting];
    NSLog(@"Language selected: %@", [availableLanguages[row] bcp47]);
}

#pragma mark - UIPickerViewDatasource methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [availableLanguages count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
