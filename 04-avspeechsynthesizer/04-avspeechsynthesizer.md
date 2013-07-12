# iOS7 Day-by-Day: Day 4
## Speech Synthesis with AVSpeechSynthesizer

### Introduction

iOS has had speech synthesis as part of siri since iOS 5, but it was never
exposed as functionality accessible via a public API. iOS 7 changes this, with
a simple API - `AVSpeechSynthesizer`.

### Voices

iOS 7 contains a set of different voices which can be used for speech synthesis.
You can use these to specify the language and variant you wish to synthesize.
`AVSpeechSynthesisVoice:speechVoices` returns an array of the available voices:

    2013-07-12 10:49:26.929 GreetingSpeaker[31267:70b] (
        "[AVSpeechSynthesisVoice 0x978a0b0] Language: th-TH",
        "[AVSpeechSynthesisVoice 0x977a450] Language: pt-BR",
        "[AVSpeechSynthesisVoice 0x977a480] Language: sk-SK",
        "[AVSpeechSynthesisVoice 0x978ad50] Language: fr-CA",
        "[AVSpeechSynthesisVoice 0x978ada0] Language: ro-RO",
        "[AVSpeechSynthesisVoice 0x97823f0] Language: no-NO",
        "[AVSpeechSynthesisVoice 0x978e7b0] Language: fi-FI",
        "[AVSpeechSynthesisVoice 0x978af50] Language: pl-PL",
        "[AVSpeechSynthesisVoice 0x978afa0] Language: de-DE",
        "[AVSpeechSynthesisVoice 0x978e390] Language: nl-NL",
        "[AVSpeechSynthesisVoice 0x978b030] Language: id-ID",
        "[AVSpeechSynthesisVoice 0x978b080] Language: tr-TR",
        "[AVSpeechSynthesisVoice 0x978b0d0] Language: it-IT",
        "[AVSpeechSynthesisVoice 0x978b120] Language: pt-PT",
        "[AVSpeechSynthesisVoice 0x978b170] Language: fr-FR",
        "[AVSpeechSynthesisVoice 0x978b1c0] Language: ru-RU",
        "[AVSpeechSynthesisVoice 0x978b210] Language: es-MX",
        "[AVSpeechSynthesisVoice 0x978b2d0] Language: zh-HK",
        "[AVSpeechSynthesisVoice 0x978b320] Language: sv-SE",
        "[AVSpeechSynthesisVoice 0x978b010] Language: hu-HU",
        "[AVSpeechSynthesisVoice 0x978b440] Language: zh-TW",
        "[AVSpeechSynthesisVoice 0x978b490] Language: es-ES",
        "[AVSpeechSynthesisVoice 0x978b4e0] Language: zh-CN",
        "[AVSpeechSynthesisVoice 0x978b530] Language: nl-BE",
        "[AVSpeechSynthesisVoice 0x978b580] Language: en-GB",
        "[AVSpeechSynthesisVoice 0x978b5d0] Language: ar-SA",
        "[AVSpeechSynthesisVoice 0x978b620] Language: ko-KR",
        "[AVSpeechSynthesisVoice 0x978b670] Language: cs-CZ",
        "[AVSpeechSynthesisVoice 0x978b6c0] Language: en-ZA",
        "[AVSpeechSynthesisVoice 0x978aed0] Language: en-AU",
        "[AVSpeechSynthesisVoice 0x978af20] Language: da-DK",
        "[AVSpeechSynthesisVoice 0x978b810] Language: en-US",
        "[AVSpeechSynthesisVoice 0x978b860] Language: en-IE",
        "[AVSpeechSynthesisVoice 0x978b8b0] Language: hi-IN",
        "[AVSpeechSynthesisVoice 0x978b900] Language: el-GR",
        "[AVSpeechSynthesisVoice 0x978b950] Language: ja-JP"
    )

You create a specific voice with the following class method:

    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];

If the language isn't recognized then the return value will be `nil`.

### Utterances

An utterance represents a section of speech - a collection of which can be
passed to the speech synthesizer to create a stream of speech. An utterance is
created with the string which will be spoken by the speech synthesizer:

    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Hello world!"];

We can specify the voice for an utterance with the `voice` property:

    utterence.voice = voice;

There are various other properties which can be set on an utterance, including
`rate`, `volume` and `pitchMultiplier`. For example, to slow down the speech a
little:

    utterance.rate *= 0.7;


Once an utterance has been created it can be passed to a speech synthesizer object
which will cause the audio to be generated:

    AVSpeechSynthesizer *speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    [speechSynthesizer speakUtterance:utterance];

Utterances are queued by the synthesizer, so you can continue to pass utterances
without waiting the speech to be completed. If you attempt to pass an utterance
instance which is currently in the queue then an exception will be thrown.

### Implementation

The sample project which accompanies this article is a multi-lingual greeting
app. This demonstrates the versatility of the speech synthesis functionality
present in iOS 7. 

It's important to note that the strings which define the utterances are all
specified in the roman alphabet - e.g. 'Ni hao' in Chinese. The sample project
defines a class which creates utterances for a set of languages.

The project has a picker to allow the user to choose a language and then a
button to hear the greeting spoken in the appropriate language.

### Conclusion

Speech synthesis has been made really simple in iOS 7, with a wide range of
languages. Used sensibly it has potential for improving accessibility and
enabling hands/eyes-free operation of apps.


