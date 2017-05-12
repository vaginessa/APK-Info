***************************************************** Show OS GUI language
Setting ShowOSLanguage=1 (default ShowOSLanguage=0) in the program title
you can show the OSLang code.


***************************************************** Show command line option

Setting ShowCmdLine=1 (default ShowCmdLine=0) in the program title
you can show the parameters passed to batch/command line to APK-Info.exe.


***************************************************** APK-Info shell integration

It's included a registry setting to enable sAPK.Info shell integration.
BEFORE to run it to activate shell integration, please edit the .reg.
You can do it with ex. Notepad++ and set the right path for APK-Info.exe (path without space)


********************************************** Multilanguage Info

The strings used by APK-Info GUI are located in APK-Info-GUI-Strings.ini file.
I included the string to translate (and send to me) in the "APK-Info-GUI-en-master.txt" file

To create French translation add [String-fr] section

To create Dutch translation add [String-nl] section

To create Norwegian translation add [String-no] section

To create Polish translation add [String-pl] section

To create Portuguese translation add [String-pt] section

To create Swedish translation add [String-sw] section


One time create new section copy and paste in the new section the messages 
of [Strings-en] section and translate it.

For more info about OSLang code please see on

https://www.autoitscript.com/autoit3/docs/appendix/OSLangCodes.htm

The language code already enabled as detection in the program are

ID = 0409 - Language_code="en"
ID = 040b - Language_code="fi"
ID = 040c - Language_code="fr"
ID = 0410 - Language_code="it"
ID = 0413 - Language_code="nl"
ID = 0414 - Language_code="no"
ID = 0415 - Language_code="pl"
ID = 0416 - Language_code="pt"
ID = 041b - Language_code="sk"
ID = 041d - Language_code="sw"
ID = 0807 - Language_code="de"
ID = 080a - Language_code="sp"

Language strings already included in the program are for language en, it, sk


*****************************************************Forced GUI language

ForceGUILanguage in APK-Info.ini

Setting a value for ForcedGUILanguage (default ForcedGUILanguage=0 mans auto detect)
you can force a specific language for test. Ex
ForcedGUILanguage=fr force GUI language to French.
If the language strings for the language forced are not available it will show in english.


*****************************************************APK-Info GUI translatorForced

Chinese -  Li Guiquan
French -  Yoanf_26, VSO Sofwtare
Hungarian - gidano
Indonesian - exodius48
Italian - bovirus
Polish -  Eselter
Spanish - Ksawery
Dansk - to mosu
Farsi - HesamEdin
German - to mosu
