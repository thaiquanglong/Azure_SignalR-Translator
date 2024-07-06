using System.Collections.Generic;
using System.Linq;

namespace CaptionAPI.Common
{
    public static class Constants
    {
        public static readonly IReadOnlyList<string> LANGUAGES = 
            new List<string> { "en-US", "fr-FR", "es-ES", "ko-KO", "ja-JP", "de-DE" , "prs-PRS", "vi-VN", "ar-AE", "lzh-CN", "hi-IN", "he-IL", "el-GR" };
        public static readonly IReadOnlyList<string> LANGUAGE_CODES = 
            LANGUAGES.Select(l => l.Split("-")[0]).ToList();
    }
}