using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.CognitiveServices.Speech;
using Microsoft.CognitiveServices.Speech.Audio;
using Microsoft.CognitiveServices.Speech.Translation;
using Speech_translate_console;
using Newtonsoft.Json.Linq;


public class Program
{


    static string SPEECH__SERVICE__KEY = "";

    static string SPEECH__SERVICE__REGION = "";

    static Task Main() => TranslateSpeechAsync();

    static async Task TranslateSpeechAsync()
    {
        // Path to the JSON file
        string filePath = "../Infra_Creation/keys.json";


        // Read the JSON file content
        string jsonContent = File.ReadAllText(filePath);

        // Parse the JSON content
        JObject jsonObject = JObject.Parse(jsonContent);

        // Get the value of "ai_speech_endpoint"
        SPEECH__SERVICE__KEY = jsonObject["ai_speech_key"]["value"].ToString();
        SPEECH__SERVICE__REGION = jsonObject["region"]["value"].ToString();

        // Display the value
        Console.WriteLine("ai_speech_endpoint value: " + SPEECH__SERVICE__KEY);
        var speechTranslationConfig =
            SpeechTranslationConfig.FromSubscription(SPEECH__SERVICE__KEY, SPEECH__SERVICE__REGION);

        var fromLanguage = "en-US";
        var toLanguages = new List<string> { "de", "en", "it", "pt", "zh-Hans" };
        speechTranslationConfig.SpeechRecognitionLanguage = fromLanguage;
        toLanguages.ForEach(speechTranslationConfig.AddTargetLanguage);

        using var translationRecognizer = new TranslationRecognizer(speechTranslationConfig);

        Console.Write($"Say something in '{fromLanguage}' and ");
        Console.WriteLine($"we'll translate into '{string.Join("', '", toLanguages)}'.\n");

        var result = await translationRecognizer.RecognizeOnceAsync();
        if (result.Reason == ResultReason.TranslatedSpeech)
        {
            var languageToVoiceMap = new Dictionary<string, string>
            {
                ["de"] = "de-DE-KatjaNeural",
                ["en"] = "en-US-AriaNeural",
                ["it"] = "it-IT-ElsaNeural",
                ["pt"] = "pt-BR-FranciscaNeural",
                ["zh-Hans"] = "zh-CN-XiaoxiaoNeural"
            };

            Console.WriteLine($"Recognized: \"{result.Text}\"");

            foreach (var (language, translation) in result.Translations)
            {
                Console.WriteLine($"Translated into '{language}': {translation}");

                var speechConfig =
                    SpeechConfig.FromSubscription(
                        SPEECH__SERVICE__KEY, SPEECH__SERVICE__REGION);
                speechConfig.SpeechSynthesisVoiceName = languageToVoiceMap[language];

                /** Uncomment this for Text to Audio
                using var audioConfig = AudioConfig.FromWavFileOutput($"{language}-translation.wav");
                using var speechSynthesizer = new SpeechSynthesizer(speechConfig, audioConfig);

                await speechSynthesizer.SpeakTextAsync(translation);
                */
            }
        }
    }
}