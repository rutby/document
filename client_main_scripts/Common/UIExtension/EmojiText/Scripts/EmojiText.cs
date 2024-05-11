using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System;
using System.IO;
using System.Text;
using GameFramework;
// using Sirenix.Utilities.Editor;
 

public class EmojiText : Text
{
    // private const string regex1 =
    //     @"[0-9|#]\u20E3" +
    //     @"|[\u0023|\u002a|\u0030-\u0039]\ufe0f\u20e3" + 
    //     @"|[\u261d|\u270a-\u270d]\ud83c[\udffb-\udfff]" +  
    //     @"|\u26f9\ufe0f\u200d[\u2640|\u2642]\ufe0f" + 
    //     @"|\u26f9\ud83c[\udffb-\udfff]\u200d[\u2640|\u2642]\ufe0f" + 
    //     @"|\ud83c[\udfc3|\udfcb]\ud83c[\udffb-\udfff]\u200d[\u2640|\u2642]\ufe0f" + 
    //     @"|\ud83c[\udfc3|\udfc4|\udfca]\u200d[\u2640|\u2642]\ufe0f"  + 
    //     @"|\ud83c[\udfcb-\udfcc]\ufe0f\u200d[\u2640|\u2642]\ufe0f" + 
    //     @"|\ud83c[\udfc4|\udfca|\udfcc]\ud83c[\udffb-\udfff]\u200d[\u2640|\u2642]\ufe0f" + 
    //     @"|\ud83c[\udf85|\udfc3|\udfc7]\ud83c[\udffb-\udfff]" + 
    //     @"|\ud83c\udff4\u200d\u2620\ufe0f" + 
    //     @"|\ud83c\udff3\ufe0f\u200d\ud83c\udf08" + 
    //     @"|\ud83c[\ud000-\udfff]" + 
    //     @"|\ud83d[\ude45|\ude46|\ude47|\ude4b|\ude4d|\ude4e|\udc6e|\udc6f|\udc71|\udc73|\udc77|\udc81|\udc82|\udc86|\udc87|\udea3-\udeb6]\u200d[\u2640|\u2642]\ufe0f" + 
    //     @"|\ud83d[\udc68-\udc69]\u200d\ud83e[\uddb0-\uddb3]" + 
    //     @"|\ud83d[\udc68-\udc69]\u200d[\u2695-\u2696]\ufe0f" + 
    //     @"|\ud83d[\udc68-\udc69]\u200d\ud83c[\udf3e|\udf73|\udf93|\udfa4|\udfa8|\udfeb|\udfed]" + 
    //     @"|\ud83d[\udc68-\udc69]\u200d\ud83d[\udc66-\udc69]\u200d\ud83d[\udc66-\udc67]\u200d\ud83d[\udc66-\udc67]" + 
    //     @"|\ud83d[\udc68-\udc69]\u200d\ud83d[\udc66-\udc69]\u200d\ud83d[\udc66-\udc67]" + 
    //     @"|\ud83d[\udc41|\udc68-\udc69]\u200d\ud83d[\udc66|\udc67|\udcbb|\udcbc|\udd27|\udd2c|\udde8|\ude80|\ude92]" + 
    //     @"|\ud83d[\udc68-\udc69]\u200d\u2708\ufe0f"  + 
    //     @"|\ud83d[\udc68-\udc69]\u200d\u2764\ufe0f\u200d\ud83d[\udc68-\udc69]" + 
    //     @"|\ud83d[\udc68-\udc69]\u200d\u2764\ufe0f\u200d\ud83d\udc8b\u200d\ud83d[\udc68-\udc69]"+ 
    //     @"|\ud83d[\udc68-\udc69]\ud83c\udffb\u200d[\u2695-\u2696]\ufe0f" + 
    //     @"|\ud83d[\udc68-\udc69]\ud83c\udffb\u200d\ud83c[\udf3e|\udf73|\udf93|\udfa4|\udfa8|\udfeb|\udfed]" + 
    //     @"|\ud83d[\udc68-\udc69]\ud83c\udffb\u200d\ud83d[\udcbb|\udcbc|\udd27|\udd2c|\ude80|\ude92]" + 
    //     @"|\ud83d[\udc68-\udc69]\ud83c[\udffb-\udfff]\u200d[\u2695-\u2696|\u2708][\ufe0f]?"  + 
    //     @"|\ud83d[\udc68-\udc69]\ud83c[\udffc-\udfff]\u200d\ud83c[\udf3e|\udf73|\udf93|\udfa8|\udfa4|\udfeb|\udfed]" + 
    //     @"|\ud83d[\udc68-\udc69]\ud83c[\udffc-\udfff]\u200d\ud83d[\udcbb|\udcbc|\udd27|\udd2c|\ude80|\ude92]" + 
    //     @"|\ud83d[\udc6e|\udea3-\udeb6]\ud83c[\udffb-\udfff]\u200d[\u2640|\u2642]\ufe0f"  + 
    //     @"|\ud83d[\udc71|\udc73|\udd75|\udc6e|\udc77|\udc82|\ude47]\ud83c[\udffb-\udfff]\u200d[\u2640|\u2642]\ufe0f" + 
    //     @"|\ud83d[\udc81|\ude45|\ude46|\ude4b|\ude4e|\ude4d|\udc86|\udc87]\ud83c[\udffb-\udfff]\u200d[\u2640|\u2642]\ufe0f" + 
    //     @"|\ud83d\udd75\ufe0f\u200d[\u2640|\u2642]\ufe0f" + 
    //     @"|\ud83d[\ud000-\udfff]\ud83c[\ud000-\udfff]"  + 
    //     @"|\ud83d[\ud000-\udfff]" + 
    //     @"|\ud83e[\uddb8-\uddb9]\u200d[\u2640|\u2642|\u2708]\ufe0f"  + 
    //     @"|\ud83e[\uddd9-\udddf]\u200d[\u2640|\u2642]\ufe0f"  + 
    //     @"|\ud83e[\udd26|\udd37-\udd39|\udd3c-\udd3d|\udd3e|\uddd6]\u200d[\u2640|\u2642]\ufe0f"  + 
    //     @"|\ud83e[\udd26|\udd37-\udd39|\udd3d|\udd3e|\uddd7|\uddd8]\ud83c[\udffb-\udfff]\u200d[\u2640|\u2642]\ufe0f"  + 
    //     @"|\ud83e[\ud000-\udfff]\ud83c[\ud000-\udfff]"  + 
    //     @"|\ud83e[\ud000-\udfff]"  + 
    //     @"|[\uD800-\uDBFF][\uDC00-\uDFFF][\uFE0F]?" +
    //     @"|\u00a9|\u00ae";
    
    // https://stackoverflow.com/questions/46905176/detecting-all-emojis
    // https://unicode.org/Public/emoji/14.0/emoji-test.txt
    // Emoji更新了一版本，更新到V14.0
    private const string regex1 = @"[#*0-9]\uFE0F?\u20E3|©\uFE0F?|[®\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA]\uFE0F?|[\u231A\u231B]|[\u2328\u23CF]\uFE0F?|[\u23E9-\u23EC]|[\u23ED-\u23EF]\uFE0F?|\u23F0|[\u23F1\u23F2]\uFE0F?|\u23F3|[\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC]\uFE0F?|[\u25FD\u25FE]|[\u2600-\u2604\u260E\u2611]\uFE0F?|[\u2614\u2615]|\u2618\uFE0F?|\u261D(?:\uD83C[\uDFFB-\uDFFF]|\uFE0F)?|[\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642]\uFE0F?|[\u2648-\u2653]|[\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E]\uFE0F?|\u267F|\u2692\uFE0F?|\u2693|[\u2694-\u2697\u2699\u269B\u269C\u26A0]\uFE0F?|\u26A1|\u26A7\uFE0F?|[\u26AA\u26AB]|[\u26B0\u26B1]\uFE0F?|[\u26BD\u26BE\u26C4\u26C5]|\u26C8\uFE0F?|\u26CE|[\u26CF\u26D1\u26D3]\uFE0F?|\u26D4|\u26E9\uFE0F?|\u26EA|[\u26F0\u26F1]\uFE0F?|[\u26F2\u26F3]|\u26F4\uFE0F?|\u26F5|[\u26F7\u26F8]\uFE0F?|\u26F9(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?|\uFE0F(?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\u26FA\u26FD]|\u2702\uFE0F?|\u2705|[\u2708\u2709]\uFE0F?|[\u270A\u270B](?:\uD83C[\uDFFB-\uDFFF])?|[\u270C\u270D](?:\uD83C[\uDFFB-\uDFFF]|\uFE0F)?|\u270F\uFE0F?|[\u2712\u2714\u2716\u271D\u2721]\uFE0F?|\u2728|[\u2733\u2734\u2744\u2747]\uFE0F?|[\u274C\u274E\u2753-\u2755\u2757]|\u2763\uFE0F?|\u2764(?:\u200D(?:\uD83D\uDD25|\uD83E\uDE79)|\uFE0F(?:\u200D(?:\uD83D\uDD25|\uD83E\uDE79))?)?|[\u2795-\u2797]|\u27A1\uFE0F?|[\u27B0\u27BF]|[\u2934\u2935\u2B05-\u2B07]\uFE0F?|[\u2B1B\u2B1C\u2B50\u2B55]|[\u3030\u303D\u3297\u3299]\uFE0F?|\uD83C(?:[\uDC04\uDCCF]|[\uDD70\uDD71\uDD7E\uDD7F]\uFE0F?|[\uDD8E\uDD91-\uDD9A]|\uDDE6\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF]|\uDDE7\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF]|\uDDE8\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF]|\uDDE9\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF]|\uDDEA\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA]|\uDDEB\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7]|\uDDEC\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE]|\uDDED\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA]|\uDDEE\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9]|\uDDEF\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5]|\uDDF0\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF]|\uDDF1\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE]|\uDDF2\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF]|\uDDF3\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF]|\uDDF4\uD83C\uDDF2|\uDDF5\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE]|\uDDF6\uD83C\uDDE6|\uDDF7\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC]|\uDDF8\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF]|\uDDF9\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF]|\uDDFA\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF]|\uDDFB\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA]|\uDDFC\uD83C[\uDDEB\uDDF8]|\uDDFD\uD83C\uDDF0|\uDDFE\uD83C[\uDDEA\uDDF9]|\uDDFF\uD83C[\uDDE6\uDDF2\uDDFC]|\uDE01|\uDE02\uFE0F?|[\uDE1A\uDE2F\uDE32-\uDE36]|\uDE37\uFE0F?|[\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20]|[\uDF21\uDF24-\uDF2C]\uFE0F?|[\uDF2D-\uDF35]|\uDF36\uFE0F?|[\uDF37-\uDF7C]|\uDF7D\uFE0F?|[\uDF7E-\uDF84]|\uDF85(?:\uD83C[\uDFFB-\uDFFF])?|[\uDF86-\uDF93]|[\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F]\uFE0F?|[\uDFA0-\uDFC1]|\uDFC2(?:\uD83C[\uDFFB-\uDFFF])?|[\uDFC3\uDFC4](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDFC5\uDFC6]|\uDFC7(?:\uD83C[\uDFFB-\uDFFF])?|[\uDFC8\uDFC9]|\uDFCA(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDFCB\uDFCC](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?|\uFE0F(?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDFCD\uDFCE]\uFE0F?|[\uDFCF-\uDFD3]|[\uDFD4-\uDFDF]\uFE0F?|[\uDFE0-\uDFF0]|\uDFF3(?:\u200D(?:\u26A7\uFE0F?|\uD83C\uDF08)|\uFE0F(?:\u200D(?:\u26A7\uFE0F?|\uD83C\uDF08))?)?|\uDFF4(?:\u200D\u2620\uFE0F?|\uDB40\uDC67\uDB40\uDC62\uDB40(?:\uDC65\uDB40\uDC6E\uDB40\uDC67|\uDC73\uDB40\uDC63\uDB40\uDC74|\uDC77\uDB40\uDC6C\uDB40\uDC73)\uDB40\uDC7F)?|[\uDFF5\uDFF7]\uFE0F?|[\uDFF8-\uDFFF])|\uD83D(?:[\uDC00-\uDC07]|\uDC08(?:\u200D\u2B1B)?|[\uDC09-\uDC14]|\uDC15(?:\u200D\uD83E\uDDBA)?|[\uDC16-\uDC3A]|\uDC3B(?:\u200D\u2744\uFE0F?)?|[\uDC3C-\uDC3E]|\uDC3F\uFE0F?|\uDC40|\uDC41(?:\u200D\uD83D\uDDE8\uFE0F?|\uFE0F(?:\u200D\uD83D\uDDE8\uFE0F?)?)?|[\uDC42\uDC43](?:\uD83C[\uDFFB-\uDFFF])?|[\uDC44\uDC45]|[\uDC46-\uDC50](?:\uD83C[\uDFFB-\uDFFF])?|[\uDC51-\uDC65]|[\uDC66\uDC67](?:\uD83C[\uDFFB-\uDFFF])?|\uDC68(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D(?:\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?|[\uDC68\uDC69]\u200D\uD83D(?:\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?)|[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92])|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C(?:\uDFFB(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFC-\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFC(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB\uDFFD-\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFD(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFE(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB-\uDFFD\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFF(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB-\uDFFE]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?))?|\uDC69(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?[\uDC68\uDC69]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D(?:\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?|\uDC69\u200D\uD83D(?:\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?)|[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92])|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C(?:\uDFFB(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF]|\uDC8B\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFC-\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFC(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF]|\uDC8B\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB\uDFFD-\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFD(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF]|\uDC8B\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFE(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF]|\uDC8B\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFD\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFF(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF]|\uDC8B\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFE]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?))?|\uDC6A|[\uDC6B-\uDC6D](?:\uD83C[\uDFFB-\uDFFF])?|\uDC6E(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDC6F(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDC70\uDC71](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDC72(?:\uD83C[\uDFFB-\uDFFF])?|\uDC73(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDC74-\uDC76](?:\uD83C[\uDFFB-\uDFFF])?|\uDC77(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDC78(?:\uD83C[\uDFFB-\uDFFF])?|[\uDC79-\uDC7B]|\uDC7C(?:\uD83C[\uDFFB-\uDFFF])?|[\uDC7D-\uDC80]|[\uDC81\uDC82](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDC83(?:\uD83C[\uDFFB-\uDFFF])?|\uDC84|\uDC85(?:\uD83C[\uDFFB-\uDFFF])?|[\uDC86\uDC87](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDC88-\uDC8E]|\uDC8F(?:\uD83C[\uDFFB-\uDFFF])?|\uDC90|\uDC91(?:\uD83C[\uDFFB-\uDFFF])?|[\uDC92-\uDCA9]|\uDCAA(?:\uD83C[\uDFFB-\uDFFF])?|[\uDCAB-\uDCFC]|\uDCFD\uFE0F?|[\uDCFF-\uDD3D]|[\uDD49\uDD4A]\uFE0F?|[\uDD4B-\uDD4E\uDD50-\uDD67]|[\uDD6F\uDD70\uDD73]\uFE0F?|\uDD74(?:\uD83C[\uDFFB-\uDFFF]|\uFE0F)?|\uDD75(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?|\uFE0F(?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDD76-\uDD79]\uFE0F?|\uDD7A(?:\uD83C[\uDFFB-\uDFFF])?|[\uDD87\uDD8A-\uDD8D]\uFE0F?|\uDD90(?:\uD83C[\uDFFB-\uDFFF]|\uFE0F)?|[\uDD95\uDD96](?:\uD83C[\uDFFB-\uDFFF])?|\uDDA4|[\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA]\uFE0F?|[\uDDFB-\uDE2D]|\uDE2E(?:\u200D\uD83D\uDCA8)?|[\uDE2F-\uDE34]|\uDE35(?:\u200D\uD83D\uDCAB)?|\uDE36(?:\u200D\uD83C\uDF2B\uFE0F?)?|[\uDE37-\uDE44]|[\uDE45-\uDE47](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDE48-\uDE4A]|\uDE4B(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDE4C(?:\uD83C[\uDFFB-\uDFFF])?|[\uDE4D\uDE4E](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDE4F(?:\uD83C[\uDFFB-\uDFFF])?|[\uDE80-\uDEA2]|\uDEA3(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDEA4-\uDEB3]|[\uDEB4-\uDEB6](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDEB7-\uDEBF]|\uDEC0(?:\uD83C[\uDFFB-\uDFFF])?|[\uDEC1-\uDEC5]|\uDECB\uFE0F?|\uDECC(?:\uD83C[\uDFFB-\uDFFF])?|[\uDECD-\uDECF]\uFE0F?|[\uDED0-\uDED2\uDED5-\uDED7]|[\uDEE0-\uDEE5\uDEE9]\uFE0F?|[\uDEEB\uDEEC]|[\uDEF0\uDEF3]\uFE0F?|[\uDEF4-\uDEFC\uDFE0-\uDFEB])|\uD83E(?:\uDD0C(?:\uD83C[\uDFFB-\uDFFF])?|[\uDD0D\uDD0E]|\uDD0F(?:\uD83C[\uDFFB-\uDFFF])?|[\uDD10-\uDD17]|[\uDD18-\uDD1C](?:\uD83C[\uDFFB-\uDFFF])?|\uDD1D|[\uDD1E\uDD1F](?:\uD83C[\uDFFB-\uDFFF])?|[\uDD20-\uDD25]|\uDD26(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDD27-\uDD2F]|[\uDD30-\uDD34](?:\uD83C[\uDFFB-\uDFFF])?|\uDD35(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDD36(?:\uD83C[\uDFFB-\uDFFF])?|[\uDD37-\uDD39](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDD3A|\uDD3C(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDD3D\uDD3E](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDD3F-\uDD45\uDD47-\uDD76]|\uDD77(?:\uD83C[\uDFFB-\uDFFF])?|[\uDD78\uDD7A-\uDDB4]|[\uDDB5\uDDB6](?:\uD83C[\uDFFB-\uDFFF])?|\uDDB7|[\uDDB8\uDDB9](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDDBA|\uDDBB(?:\uD83C[\uDFFB-\uDFFF])?|[\uDDBC-\uDDCB]|[\uDDCD-\uDDCF](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDDD0|\uDDD1(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83E\uDDD1|[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83C(?:\uDFFB(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFC-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFC(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB\uDFFD-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFD(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFE(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB-\uDFFD\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?|\uDFFF(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB-\uDFFE]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF]|[\uDDAF-\uDDB3\uDDBC\uDDBD])))?))?|[\uDDD2\uDDD3](?:\uD83C[\uDFFB-\uDFFF])?|\uDDD4(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|\uDDD5(?:\uD83C[\uDFFB-\uDFFF])?|[\uDDD6-\uDDDD](?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF](?:\u200D[\u2640\u2642]\uFE0F?)?)?|[\uDDDE\uDDDF](?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDDE0-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])";
    private const string regex2 = @"<sprite=([a-z0-9A-Z]+)>";
    private const string regex3 = @"<\|>";
    private const string regex4 = @"<color=#[a-z0-9A-Z]+>" +
                                  @"|</color>";
    
    // 预先编译好要用的正则表达式
    static Regex Regex1 = new Regex(regex1, RegexOptions.Compiled);
    static Regex Regex2 = new Regex(regex2, RegexOptions.Compiled);
    static Regex Regex3 = new Regex(regex3, RegexOptions.Compiled);
    static Regex Regex4 = new Regex(regex4, RegexOptions.Compiled);
    static Regex RegexWhitespace = new Regex(@"\s", RegexOptions.Compiled);
    
    //用来做省略号使用的
    static TextGenerator _generator = new TextGenerator();
    private List<string> emojiHolderList = new List<string>(16);
    private const string emojiPlaceHolder = "<|>";
    [SerializeField] private bool m_useTextWithEllipsis= false;
    
    // 渲染时的临时emoji词典
    private static Dictionary<int, EmojiFrame> emojiDic = new Dictionary<int, EmojiFrame>();
    // emoji词典
    private static readonly Dictionary<string, EmojiFrame> emojiFrames = new Dictionary<string, EmojiFrame>();
    private static readonly Dictionary<string, string> emojiFastSearch = new Dictionary<string, string>();
    
    // 这里使用StringBuilder进行一下加速
    private static StringBuilder sb_ = new StringBuilder(128);
    private static byte[] utf32_bytes_ = new byte[64];
    private static StringBuilder utf32_sb_ = new StringBuilder(64);
    private static string[] b2str_ = {"00", "01", "02", "03", "04", "05", "06", "07", "08", "09"};
    
    // 是否支持emoji
    public bool supportEmoji = true;
    
    // 
    private float m_IconScaleOfDoubleSymbole = 1.0f;
    private bool m_EmojiParsingRequired = true;
    private string m_EmojiText;
    private readonly UIVertex[] m_TempVerts = new UIVertex[4];

    public override float preferredWidth => cachedTextGeneratorForLayout.GetPreferredWidth(emojiText, GetGenerationSettings(rectTransform.rect.size)) / pixelsPerUnit;

    public override float preferredHeight => cachedTextGeneratorForLayout.GetPreferredHeight(emojiText, GetGenerationSettings(rectTransform.rect.size)) / pixelsPerUnit;

    public string emojiText
    {
        get
        {
            if (!string.IsNullOrEmpty(text))
            {
                // return Regex.Replace(text, regex1, "%?"); //用着两个字符占位 渲染出来就是这两个字符渲染出来的大小
                return Regex1.Replace(text, "%?");
            }
            else
                return text;
        }
    }
    StringBuilder _stringBuilder = new StringBuilder(50);
    private bool _lock = false;
    private string _compareValue = "";
    private string[] FixedText= new string[30];
    private string[] Holder= new string[5];
    private string TextHolder;
    private int startIndex;
    private int endIndex;
    private int length;
    public override string text
    {
        get
        {
            string baseText = m_Text;
            return baseText;
        }
        set
        {
            if (String.IsNullOrEmpty(value))
            {
                if (String.IsNullOrEmpty(m_Text))
                    return;
                m_Text = "";
                SetVerticesDirty();
            }
            else
            {
                value = GetRealValue(value);
// #if UNITY_ANDROID || UNITY_EDITOR
                if (IsRtl(value))
                {
                    value = FixText(value);
                }
// #endif
                if (m_Text != value)
                {
                    m_Text = GetRealValue(value);
                    SetVerticesDirty();
                    SetLayoutDirty();
                }
            }
            
        }
    }

    private int AppendString(int lastIndex, string value, int startIndex, string appendStr)
    {
        // 附加之前的一段（即指的是两个Emoji中间的正常文本）
        int len = startIndex - lastIndex;
        if (lastIndex >= 0 && lastIndex < value.Length &&
            len >= 0 && lastIndex + len < value.Length)
        {
            sb_.Append(value, lastIndex, len);
        }
        else
        {
            Log.Error("offset out of range!");
        }

        // 附加改变的一段（Emoji变成图片）
        if (!string.IsNullOrEmpty(appendStr))
        {
            sb_.Append(appendStr);
        }

        return 0;
    }

    private bool IsRtl(string str)
    {
        var isRtl = false;
        foreach (var _char in str)
        {
            if ((_char >= 1536 && _char <= 1791) || (_char >= 65136 && _char <= 65279))
            {
                isRtl = true;
                break;
            }
        }
        return isRtl;
    }
    private string GetRealValue(string value)
    {
        emojiHolderList.Clear();
        sb_.Clear();
        if (!m_useTextWithEllipsis)
            return value;
        
        // value = Regex.Replace(value, regex4, "");
        value = Regex4.Replace(value, "");
        
         // MatchCollection matches = Regex.Matches(value, regex1);
        MatchCollection matches = Regex1.Matches(value);
        int lastIndex = 0;
        for (int i = 0; i < matches.Count; ++i)
        {
            emojiHolderList.Add(matches[i].Value);

            AppendString(lastIndex, value, matches[i].Index, emojiPlaceHolder);
            lastIndex = matches[i].Index + matches[i].Length;
        }

        if (value.Length - lastIndex > 0)
        {
            sb_.Append(value, lastIndex, value.Length - lastIndex);
        }

        value = sb_.ToString();
        value = GetTextWithEllipsis(value);
        
        sb_.Clear();
        lastIndex = 0;
        
        // MatchCollection matches2 = Regex.Matches(value, regex3);
        MatchCollection matches2 = Regex3.Matches(value);
        for (int i = 0; i < matches2.Count; ++i)
        {
            string str = GetEmojiByIndex(i);
            // value = ReplaceFirst(value, matches2[i].Value, str);
            
            AppendString(lastIndex, value, matches2[i].Index, str);
            lastIndex = matches2[i].Index + matches2[i].Length;
        }
        if (value.Length - lastIndex > 0)
        {
            sb_.Append(value, lastIndex, value.Length - lastIndex);
        }

        value = sb_.ToString();
        var real = value;
        return real;
    }

    private string GetEmojiByIndex(int index)
    {
        if (emojiHolderList.Count <= index)
            return "";
        return emojiHolderList[index];
    }

    private string GetTextWithEllipsis(string value)
    {
        bool _lock = false;
        sb_.Clear();
        var settings = GetGenerationSettings(rectTransform.rect.size);
        _generator.Populate(value, settings);
        var characterCountVisible = _generator.characterCountVisible;
        if (characterCountVisible > 0 && characterCountVisible >= value.Length )
            return value;
        characterCountVisible -= 3; //用来填充 ...
        characterCountVisible = characterCountVisible > 0 ? characterCountVisible : 0;
        var updatedText = value;
        if (characterCountVisible>0 && value.Length > characterCountVisible)
        {
            int valueLength = value.Length;
            int visibleCharactorIndex = 0;
            for (int i = 0; i < valueLength; ++i)
            {
                if (!_lock && i > characterCountVisible)
                    break;
                
                if (value[i] == '<')
                {
                    _lock = true;
                }
                if (value[i] == '>')
                {
                    _lock = false;
                }
                sb_.Append(value[i]);
            }
            sb_.Append("...");
            updatedText = sb_.ToString();
        }

        return updatedText;
    }
    
    public override void SetVerticesDirty()
    {
        m_EmojiParsingRequired = supportEmoji;

        base.SetVerticesDirty();
    }

    public bool IsContainsEmoji()
    {
        return ParseText();
    }

    private string FixText(string value)
    {
        m_DisableFontTextureRebuiltCallback = true;
        var tempText = "";
        var finalTxt = "";
        _lock = false;
        _stringBuilder.Clear();
        _compareValue = "";
        for (int i = 0; i < value.Length; ++i)
        {
            if (value[i] == '<')
            {
                _lock = true;
                continue;
            }
            if (value[i] == '>')
            {
                _lock = false;
                continue;
            }

            if (!_lock)
                _stringBuilder.Append(value[i]);
        }
        tempText = _stringBuilder.ToString();
        Holder = tempText.Split('\n');
        for (int i = 0; i < Holder.Length; i++)
        {
            int templinesCount = 0;
            finalTxt = ArabicSupport.ArabicFixer.Fix(Holder[i], true, false);
            cachedTextGenerator.PopulateWithErrors(finalTxt, GetGenerationSettings(rectTransform.rect.size),
                gameObject);
            for (int k = 0; k < FixedText.Length; k++)
            {
                FixedText[k] = "";
            }

            for (int k = 0; k < cachedTextGenerator.lines.Count; k++)
            {
                startIndex = cachedTextGenerator.lines[k].startCharIdx;
                endIndex = (k == cachedTextGenerator.lines.Count - 1)
                    ? finalTxt.Length
                    : cachedTextGenerator.lines[k + 1].startCharIdx;
                length = endIndex - startIndex;
                FixedText[k] = finalTxt.Substring(startIndex, length);
                templinesCount = k;
            }

            finalTxt = "";
            //如果是最后一个字段的最后一行的话不用换行。
            if (i == Holder.Length - 1)
            {
                for (int k = FixedText.Length - 1; k >= 0; k--)
                {
                    if (FixedText[k] != "" && FixedText[k] != "\n" && FixedText[k] != null)
                    {
                        if (templinesCount == 0)
                        {
                            TextHolder += FixedText[k];
                        }
                        else
                        {
                            TextHolder += FixedText[k];
                        }
                    }
                }
            }
            else
            {
                for (int k = FixedText.Length - 1; k >= 0; k--)
                {
                    if (FixedText[k] != "" && FixedText[k] != "\n" && FixedText[k] != null)
                    {
                        TextHolder += FixedText[k] + "\n";
                    }
                }
            }
        }

        finalTxt = TextHolder;
        TextHolder = "";
        m_DisableFontTextureRebuiltCallback = false;
        return finalTxt;
    }
    private void initEmoji()
    {
        // if (emojiData.frames == null || emojiData.frames.Length == 0)
        if (emojiFrames.Count > 0)
        {
            return;
        }

        // 这个文件由Editor里面的工具生成
        // "Tools/Export_EmojiData"
        try
        {
            TextAsset asset = Resources.Load<TextAsset>("texturepacker_EmojiData_bin");
            if (asset != null)
            {
                Stream stream = new MemoryStream(asset.bytes);
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    while (reader.BaseStream.Position < reader.BaseStream.Length)
                    {
                        string name = reader.ReadString();

                        EmojiFrame frame;
                        frame.filename = reader.ReadString();

                        frame.frame.x = reader.ReadSingle();
                        frame.frame.y = reader.ReadSingle();
                        frame.frame.w = reader.ReadSingle();
                        frame.frame.h = reader.ReadSingle();

                        frame.rotated = reader.ReadBoolean();
                        frame.trimmed = reader.ReadBoolean();

                        frame.spriteSourceSize.x = reader.ReadSingle();
                        frame.spriteSourceSize.y = reader.ReadSingle();
                        frame.spriteSourceSize.w = reader.ReadSingle();
                        frame.spriteSourceSize.h = reader.ReadSingle();

                        frame.sourceSize.w = reader.ReadSingle();
                        frame.sourceSize.h = reader.ReadSingle();

                        frame.pivot.x = reader.ReadSingle();
                        frame.pivot.y = reader.ReadSingle();

                        // emojiFrames[name] = frame;
                        emojiFrames.Add(name, frame);
                    }
                }
            }
            else
            {
                Debug.Log("OnPopulateMesh : asset is null!!!");
            }
        }
        catch (Exception e)
        {
            Debug.Log("OnPopulateMesh : exception!!!");
        }
    }

    protected override void OnPopulateMesh(VertexHelper toFill)
    {
        if (font == null)
            return;

        // 初始化静态emoji库
        initEmoji();

        if (m_EmojiParsingRequired)
        {
            ParseText();
        }

        emojiDic.Clear();

        if (supportEmoji)
        {
            int nParcedCount = 0;
            int nOffset = 0;
            
            //因为空格不会被渲染 所以过滤空格
            // MatchCollection matches = Regex.Matches(Regex.Replace(m_EmojiText, @"\s", ""),regex2);
            // 内部代码大致看了一下，如果没有产生空格替换行为的话，这里是源字符串返回的。
            m_EmojiText = RegexWhitespace.Replace(m_EmojiText, "");
            MatchCollection matches = Regex2.Matches(m_EmojiText);
            for (int i = 0; i < matches.Count; i++)
            {
                if (matches[i].Groups.Count > 1)
                {
                    if (emojiFrames.TryGetValue(matches[i].Groups[1].Value, out EmojiFrame info))
                    {
                        emojiDic.Add(matches[i].Index - nOffset + nParcedCount, info);
                        nOffset += matches[i].Length - 1;
                        nParcedCount++;
                    }
                }
            }
        }

        // We don't care if we the font Texture changes while we are doing our Update.
        // The end result of cachedTextGenerator will be valid for this instance.
        // Otherwise we can get issues like Case 619238.
        m_DisableFontTextureRebuiltCallback = true;

        Vector2 extents = rectTransform.rect.size;
        var settings = GetGenerationSettings(extents);
        cachedTextGenerator.Populate(emojiText, settings);

        // Apply the offset to the vertices
        IList<UIVertex> verts = cachedTextGenerator.verts;
        float unitsPerPixel = 1 / pixelsPerUnit;
        int vertCount = verts.Count;

        toFill.Clear();
        bool needSetOffX = false;
        for (int i = 0; i < vertCount; ++i)
        {
            int index = i / 4;
            if (emojiDic.TryGetValue(index, out EmojiFrame info))
            {
                //compute the distance of '[' and get the distance of emoji 
                //计算%?的距离
                float emojiSize = 1.45f * (verts[i + 1].position.x - verts[i].position.x) * m_IconScaleOfDoubleSymbole;

                float fCharHeight = verts[i + 1].position.y - verts[i + 2].position.y;
                float fCharWidth = verts[i + 1].position.x - verts[i].position.x;

                float fHeightOffsetHalf = (emojiSize - fCharHeight) * 0.5f;
                float fStartOffset = 4 + emojiSize * (1 - m_IconScaleOfDoubleSymbole);
                
                if (i > 4)
                {
                    //判断% 与上一个？是不是在一行
                    bool isWrapLine = Math.Abs(verts[i].position.y - verts[i-4].position.y) > fCharHeight;
                    if (needSetOffX && !isWrapLine)
                    {
                        //如果%与上一个？在同一行 并且需要设置偏移
                        fStartOffset -= (verts[i].position.x - verts[i - 4].position.x );
                    }
                    else if(i+ 4 < vertCount)
                    {
                        //判断% 与 ？是否换行 换行就要设置偏移
                        needSetOffX = Math.Abs(verts[i].position.y - verts[i+4].position.y) > fCharHeight;
                    }
                }
                
                m_TempVerts[3] = verts[i];//1
                m_TempVerts[2] = verts[i + 1];//2
                m_TempVerts[1] = verts[i + 2];//3
                m_TempVerts[0] = verts[i + 3];//4
                
                m_TempVerts[0].position += new Vector3(fStartOffset, -fHeightOffsetHalf, 0);
                m_TempVerts[1].position += new Vector3(fStartOffset - fCharWidth + emojiSize, -fHeightOffsetHalf, 0);
                m_TempVerts[2].position += new Vector3(fStartOffset - fCharWidth + emojiSize, fHeightOffsetHalf, 0);
                m_TempVerts[3].position += new Vector3(fStartOffset, fHeightOffsetHalf, 0);

                m_TempVerts[0].position *= unitsPerPixel;
                m_TempVerts[1].position *= unitsPerPixel;
                m_TempVerts[2].position *= unitsPerPixel;
                m_TempVerts[3].position *= unitsPerPixel;

                float x = info.frame.x / 2048;
                float y = (2048 - info.frame.y - 32) / 2048;
                float size = info.sourceSize.w / 2048;
                
                float pixelOffset = size / 64;
                m_TempVerts[0].uv1 = new Vector2(x + pixelOffset, y + pixelOffset);
                m_TempVerts[1].uv1 = new Vector2(x - pixelOffset + size, y + pixelOffset);
                m_TempVerts[2].uv1 = new Vector2(x - pixelOffset + size, y - pixelOffset + size);
                m_TempVerts[3].uv1 = new Vector2(x + pixelOffset, y - pixelOffset + size);

                toFill.AddUIVertexQuad(m_TempVerts);

                i += 4 * 2 - 1;//3;//4 * info.len - 1;
            }
            else
            {
                needSetOffX = false;
                int tempVertsIndex = i & 3;
                m_TempVerts[tempVertsIndex] = verts[i];
                m_TempVerts[tempVertsIndex].position *= unitsPerPixel;
                if (tempVertsIndex == 3)
                    toFill.AddUIVertexQuad(m_TempVerts);
            }
        }
        
        m_DisableFontTextureRebuiltCallback = false;
    }
    
    // string ReplaceFirst(string text, string search, string replace)
    // {
    //     int pos = text.IndexOf(search, StringComparison.Ordinal);
    //     if (pos < 0)
    //     {
    //         return text;
    //     }
    //     return text.Substring(0, pos) + replace + text.Substring(pos + search.Length);
    // }

    // byte -> 二进制字符串
    string ByteToBinStr(byte b)
    {
        if (b >= 0 && b <= 9)
        {
            return b2str_[b];
        }
        
        return b.ToString("x2");
    }

    // 第一次碰到emoji时的解析；因为需要变成utf32，所以这里略耗，不好还好每个emoji只执行一次
    bool DoFirstParse_UTF32(string match_string, out string key)
    {
        key = "";

        int should_len = Encoding.UTF32.GetByteCount(match_string);
        if (should_len > utf32_bytes_.Length)
        {
            utf32_bytes_ = new byte[should_len + 16];
        }
        int length = Encoding.UTF32.GetBytes(match_string, 0, match_string.Length, utf32_bytes_, 0);
        var bytes = utf32_bytes_;

        // byte[] bytes = Encoding.UTF32.GetBytes(match_string);
        // int length = bytes.Length;
        string highStr = "";
        string lowStr = "";
        if (length == 4)
        {
            utf32_sb_.Clear();
            for (int j = 0; j < 4; ++j)
            {
                // lowStr = ByteToBinStr(bytes[j]) + lowStr;
                string t = ByteToBinStr(bytes[j]);
                utf32_sb_.Insert(0, t);
            }
            // key = highStr + lowStr;
            key = utf32_sb_.ToString();
        }
        else if (length == 8)
        {
            for (int j = 0; j < 4; ++j)
            {
                highStr = ByteToBinStr(bytes[j]) + highStr;
            }
            for (int j = 4; j < 8; ++j)
            {
                lowStr = ByteToBinStr(bytes[j]) + lowStr;
            }
            key = highStr + lowStr;
        }
        else if (length % 4 == 0)
        {
            // string jointStr = "";
            // string tempStr = "";
            string tempStr2 = "";
            
            utf32_sb_.Clear();
            for (int num = 0; num < length; ++num)
            {
                string t = ByteToBinStr(bytes[num]);
                // jointStr = t + jointStr;
                utf32_sb_.Insert(0, t);
                if (num%4 == 3)
                {
                    // tempStr = tempStr + jointStr;
                    // jointStr = "";
                     
                    tempStr2 = tempStr2 + utf32_sb_.ToString();
                    utf32_sb_.Clear();
                }
            }

            key = tempStr2;
            // key = tempStr;
        }

        bool find = emojiFrames.TryGetValue(key, out EmojiFrame frame);

        if (!find)
        {
            if (highStr == "" && lowStr == "")
            {
                key = key + "0000fe0f";
                find |= emojiFrames.TryGetValue(key, out frame);
            }
            else if (highStr == "" && lowStr != "")
            {
                key = lowStr + "0000fe0f";
                find |= emojiFrames.TryGetValue(key, out frame);
            }
            else if (lowStr == "0000fe0f")
            {
                key = highStr;
                find |= emojiFrames.TryGetValue(key, out frame);
            }
            else if (lowStr == "000020e3")
            {
                key = highStr + "0000fe0f" + lowStr;
                find |= emojiFrames.TryGetValue(key, out frame);
            }
        }

        return find;
    }

    bool ParseText()
    {
        if (supportEmoji == false)
        {
            m_EmojiParsingRequired = false;
            return false;
        }
        
        var parsedEmoji = false;
        m_EmojiText = text;
        
        // MatchCollection matches = Regex.Matches(text, regex1);
        MatchCollection matches = Regex1.Matches(text);
        if (matches.Count == 0)
        {
            return parsedEmoji;
        }
        
        sb_.Clear();
        int lastIndex = 0;
        parsedEmoji = true;
        
        for (int i = 0; i < matches.Count; i++)
        {
            string key;
            if (emojiFastSearch.TryGetValue(matches[i].Value, out key))
            {
                // parsedEmoji = true;
                // m_EmojiText = ReplaceFirst(m_EmojiText,matches[i].Value,string.Format("<sprite={0}>", key));
            }
            else
            {
                bool find = DoFirstParse_UTF32(matches[i].Value, out key);
                if (find)
                {
                    // Debug.LogFormat("{0} find by {1}", key, frame.filename);
                    // 这里做了一个快速查找表，因为Emoji的判断需要变换到UTF32，每次变换太耗，所以这里做了一个utf8的快速查找。
                    emojiFastSearch.Add(matches[i].Value, key);
                    // parsedEmoji = true;
                    // m_EmojiText = ReplaceFirst(m_EmojiText,matches[i].Value,string.Format("<sprite={0}>", key));
                }
                else
                {
                    // 没有找到用一个？号表示
                    key = "00002753";
                    // Debug.LogFormat("{0} not find !!!", key);
                    emojiFastSearch.Add(matches[i].Value, key);
                    // parsedEmoji = true;
                    // m_EmojiText = ReplaceFirst(m_EmojiText,matches[i].Value,"<sprite=00002753>");
                }
            }

            // 附加正常字符串
            AppendString(lastIndex, m_EmojiText, matches[i].Index, null);
            
            // 附加改变的一段（Emoji变成图片）
            sb_.Append("<sprite=").Append(key).Append(">");
            
            // 调整index偏移
            lastIndex = matches[i].Index + matches[i].Length;
        }
        
        if (m_EmojiText.Length - lastIndex > 0)
        {
            sb_.Append(m_EmojiText, lastIndex, m_EmojiText.Length - lastIndex);
        }

        m_EmojiText = sb_.ToString();
        return parsedEmoji;
    }
}


[Serializable]
struct EmojiRect
{
    public float x, y, w, h;
}

[Serializable]
struct EmojiFloat2
{
    public float x, y;
}

[Serializable]
struct EmojiSize
{
    public float w, h;
}

[Serializable]
struct EmojiFrame
{
    public string filename;
    public EmojiRect frame;
    public bool rotated;
    public bool trimmed;
    public EmojiRect spriteSourceSize;
    public EmojiSize sourceSize;
    public EmojiFloat2 pivot;
}

[Serializable]
struct TexturePackerMeta
{
    public string app;
    public string version;
    public string image;
    public string format;
    public EmojiSize size;
    public float scale;
    public string smartupdate;
}

[Serializable]
struct EmojiAsset
{
    public EmojiFrame[] frames;
    public TexturePackerMeta meta;
}
