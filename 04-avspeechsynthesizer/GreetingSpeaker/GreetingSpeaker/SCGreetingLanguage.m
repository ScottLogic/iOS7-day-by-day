//
//  SCGreetingLanguage.m
//  GreetingSpeaker
//
//  Created by Sam Davies on 12/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

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
