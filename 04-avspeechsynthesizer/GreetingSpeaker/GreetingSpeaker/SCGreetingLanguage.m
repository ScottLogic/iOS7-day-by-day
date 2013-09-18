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


#import "SCGreetingLanguage.h"

@implementation SCGreetingLanguage

+ (instancetype)greetingLanguageWithBCP47:(NSString *)bcp47 name:(NSString *)name greeting:(NSString *)greeting
{
    SCGreetingLanguage *gl = [[SCGreetingLanguage alloc] init];
    gl.name = name;
    gl.bcp47 = bcp47;
    gl.greeting = greeting;
    
    return gl;
}

+ (NSArray *)listOfGreetings
{
    return @[
             [SCGreetingLanguage greetingLanguageWithBCP47:@"zh-CN" name:@"Chinese" greeting:@"Ni hao"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"en-US" name:@"English (American)" greeting:@"Howdy!"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"en-AU" name:@"English (Australia)" greeting:@"G'day!"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"en-GB" name:@"English (British)" greeting:@"How do you do?"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"fr-FR" name:@"French" greeting:@"Bonjour"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"de-DE" name:@"German" greeting:@"Guten Tag"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"it-IT" name:@"Italian" greeting:@"Buongiorno"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"ja-JP" name:@"Japanese" greeting:@"Kon'nichiwa"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"pt-PT" name:@"Portugese" greeting:@"Olá"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"ru-RU" name:@"Russian" greeting:@"privet"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"es-ES" name:@"Spanish" greeting:@"¡Hola!"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"th-TH" name:@"Thai" greeting:@"Sawadee Khaa"]
             ];
}


- (AVSpeechUtterance *)greetingUtterance
{
    // Find the correct voice
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:self.bcp47];
    
    // Create the utterance
    AVSpeechUtterance *utterance;
    
    if(voice) {
        utterance = [AVSpeechUtterance speechUtteranceWithString:self.greeting];
        
        // Set the voice
        utterance.voice = voice;
        
        // Slow it down a bit
        utterance.rate *= 0.7;
    }
    
    // Return the utterance
    return utterance;
}

@end
