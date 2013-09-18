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


#import <Foundation/Foundation.h>
@import AVFoundation;

@interface SCGreetingLanguage : NSObject

+ (NSArray *)listOfGreetings;
+ (instancetype)greetingLanguageWithBCP47:(NSString*)bcp47 name:(NSString*)name greeting:(NSString*)greeting;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bcp47;
@property (nonatomic, strong) NSString *greeting;

- (AVSpeechUtterance *)greetingUtterance;

@end
