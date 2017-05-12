#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=APK-Info.ico
#AutoIt3Wrapper_UseAnsi=n
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Shows info about Android Package Files (APK)
#AutoIt3Wrapper_Res_Description=APK-Info
#AutoIt3Wrapper_Res_Fileversion=0.7.0.0
#AutoIt3Wrapper_Res_LegalCopyright=zoster,CHEF-KOCH
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#pragma compile(AutoItExecuteAllowed True)
#include <Constants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <WinAPIShPath.au3>
#include <Array.au3>
#include <String.au3>
Opt("TrayMenuMode",1)
Opt("TrayIconHide",1)


; Adding the directives below, will cause your program be compiled with the indexing
; of the original lines shown in SciTE:
#AutoIt3Wrapper_Run_Before=ShowOriginalLine.exe %in%
#AutoIt3Wrapper_Run_After=ShowOriginalLine.exe %in%


Global $apk_Label, $apk_IconPath, $apk_IconName, $apk_PkgName, $apk_VersionCode, $apk_VersionName
Global $apk_Permissions, $apk_Features, $hGraphic, $hImage, $hImage_original, $apk_MinSDK, $apk_MinSDKVer, $apk_MinSDKName
Global $apk_TargetSDK, $apk_TargetSDKVer, $apk_TargetSDKName, $apk_Screens, $apk_Densities
Global $tempPath = @TempDir & "\APK-Info"
Global $Inidir, $ProgramVersion, $ProgramReleaseDate, $ForceGUILanguage
Global $IniProgramSettings, $IniGUISettings, $IniLogReport
Global $tmpArrBadge, $tmp_Filename, $dirAPK, $fileAPK,$fullPathAPK
Global $sNewFilenameAPK

$IniProgramSettings="APK-Info.ini"
$IniGUISettings="APK-Info-GUI.ini"
$IniLogReport="APK-Info-Log.ini"

; $aCmdLine[0] = number of parametrs passed to exe file
; $aCmdLine[1] = first parameter (optional) passed to exe file (apk file name)


; https://www.autoitscript.com/autoit3/docs/intro/running.htm
; An alternative to the limitation of $CmdLine[] only being able to return a maximum of 63 parameters.
Local $aCmdLine = _WinAPI_CommandLineToArgv($CmdLineRaw)
; Uncomment it to Show all cmdline parameters
;_ArrayDisplay($aCmdLine)

$Inidir= @ScriptDir & "\"

$ProgramVersion="0.7M"
$ProgramReleaseDate="17.04.2016"

; Check OS language
$OS_language=@OSLang

; more info on country code
; https://www.autoitscript.com/autoit3/docs/appendix/OSLangCodes.htm

$ForcedGUILanguage=Iniread ($Inidir & $IniProgramSettings, "Settings", "ForcedGUILanguage", "auto");
$OSLanguageCode=@OSLang
IF $ForcedGUILanguage = "auto" then
	$Language_code=Iniread ($Inidir & $IniGUISettings, "OSLanguage", @OSLang, "en");
Else
	$Language_code=$ForcedGUILanguage
EndIf

$ShowLog=Iniread ($Inidir & $IniProgramSettings, "Settings", "ShowLog", "1");
;$ShowLangCode=Iniread ($Inidir & $IniProgramSettings, "Settings", "ShowLangCode", "0");
;$ShowCmdLine=Iniread($Inidir & $IniProgramSettings,"Settings","ShowCmdLine","0");
$FileNamePrefix=Iniread ($Inidir & $IniProgramSettings, "Settings", "FileNamePrefix", "(");
$FileNameSuffix=Iniread ($Inidir & $IniProgramSettings, "Settings", "FileNameSuffix", ")");
$Lastfolder=Iniread($Inidir & $IniProgramSettings,"Settings","Lastfolder",@WorkingDir);

$String01=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String01", "Application")
$String02=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String02", "Version")
$String03=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String03", "Version Code")
$String04=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String04", "Package")
$String05=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String05", "Min. SDK")
$String06=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String06", "Traget SDK")
$String07=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String07", "Screen Size")
$String08=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String08", "Resolution")
$String09=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String09", "Permission")
$String10=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String10", "Feature")
$String11=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String11", "Current name")
$String12=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String12", "New name")
$String13=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String13", "Play Store")
$String14=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String14", "Rename File")
$String15=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String15", "Exit")
$String16=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String16", "Rename APK File")
$String17=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String17", "New APK Filename:")
$String18=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String18", "Error!")
$String19=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String19", "APK File could not be renamed.")
$String20=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String20", "Select APK file")
$String21=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String21", "Cur_Dev")
$String22=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String22", "Current Dev. Build")
$String23=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String23", "Unknown")
$String24=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String24", "Unknown")
$String25=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "String25", "Browse")
$URLPlayStore=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "URLPlaystore", "https://play.google.com/store/apps/details?id=")
$PlayStoreLanguage=Iniread ($Inidir & $IniGUISettings, "Strings-" & $Language_code, "PlayStoreLanguage", "en")

Dim $sMinAndroidString, $sTgtAndroidString

If $aCmdLine[0] > 0 Then
	$tmp_Filename = $aCmdLine[1]
Else
	$tmp_Filename = ""
EndIf

Global $fullPathAPK = _checkFileParameter($tmp_Filename)
Global $dirAPK   = _SplitPath($fullPathAPK,true)
Global $fileAPK = _SplitPath($fullPathAPK,false)

$tmpArrBadge = _getBadge($fullPathAPK)
_parseLines($tmpArrBadge)
_extractIcon($fullPathAPK, $apk_IconPath)

If $apk_MinSDKVer <> "" Then $sMinAndroidString = 'Android ' & $apk_MinSDKVer & ' (' & $apk_MinSDKName & ')'
If $apk_TargetSDKVer <> "" Then $sTgtAndroidString = 'Android ' & $apk_TargetSDKVer & ' (' & $apk_TargetSDKName & ')'

$sNewFilenameAPK = StringReplace($apk_Label, " ", " ") & $FileNamePrefix & StringReplace($apk_VersionName, " ", " ") & $FileNameSuffix & ".apk"
;_convertIcon($tempPath & "\" & $apk_IconName)


;================== GUI ===========================

$ProgramTitle="APK-Info " & $ProgramVersion & " (" & $ProgramReleaseDate & ")"
If $ShowLog="1" then
	IniWrite($Inidir & $IniLogReport, "APK_Info Version", "Program version", $ProgramVersion);
	IniWrite($Inidir & $IniLogReport, "APK_Info Version", "Program release date", $ProgramReleaseDate);
	IniWrite($Inidir & $IniLogReport, "Language", "OSLanguage", @OSLang);
	IniWrite($Inidir & $IniLogReport, "Language", "ForcedLanguage", $ForcedGUILanguage);
	IniWrite($Inidir & $IniLogReport, "IniFile", "IniFileFolderPath", $Inidir);
	IniWrite($Inidir & $IniLogReport, "IniFile", "IniFileProgramSettings", $IniProgramSettings);
	IniWrite($Inidir & $IniLogReport, "IniFile", "IniFileGuiSettings", $IniGUISettings);
	IniWrite($Inidir & $IniLogReport, "IniFile", "IniFileLogReport", $IniLogReport);
; Cleanup not defined variables
	IniWrite($Inidir & $IniLogReport, "Icon", "TempFilePath", "");
	IniWrite($Inidir & $IniLogReport, "Icon", "ApkIconeName", "");
	IniWrite($Inidir & $IniLogReport, "NewFile", "NewFilenameAPK", "");
	IniWrite($Inidir & $IniLogReport, "NewFile", "NewNameInput", "");
	IniWrite($Inidir & $IniLogReport, "OpenNewFile", "LastFileName", "");
	IniWrite($Inidir & $IniLogReport, "OpenNewFile", "TempFileName", "");
Endif
; $ProgramTitle=$ProgramTitle & "(I=" & $Inidir & ")"
; $ProgramTitle=$ProgramTitle & " " & $OSLanguageCode & " " & $Language_code
iF $aCmdLine[0] = 0 then
	IniWrite($Inidir & $IniLogReport, "CommandLine", "Parameter1", $aCmdLine[0]);
	IniWrite($Inidir & $IniLogReport, "CommandLine", "Parameter2", "");
Else
	IniWrite($Inidir & $IniLogReport, "CommandLine", "Parameter1", $aCmdLine[0]);
	IniWrite($Inidir & $IniLogReport, "CommandLine", "Parameter2", $aCmdLine[1]);
Endif
$hGUI =	GUICreate($ProgramTitle, 500, 500)

$gLbl1 =	GUICtrlCreateLabel($String01,			 8,  12, 100,  20)
$gLbl2 =	GUICtrlCreateLabel($String02,			 8,  36, 100,  20)
$gLbl3 =	GUICtrlCreateLabel($String03,			 8,  60, 100,  20)
$gLbl4 =	GUICtrlCreateLabel($String04,			 8,  84, 100,  20)
$gLbl5 =	GUICtrlCreateLabel($String05,			 8, 108, 100,  20)
$gLbl6 =	GUICtrlCreateLabel($String06,			 8, 132, 100,  20)
$gLbl7 =	GUICtrlCreateLabel($String07,			 8, 156, 100,  20)
$gLbl8 =	GUICtrlCreateLabel($String08,			 8, 180, 100,  20)

$Input1 =	GUICtrlCreateInput($apk_Label,			125,   9, 300,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Input2 =	GUICtrlCreateInput($apk_VersionName,	125,  33, 300,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Input3 =	GUICtrlCreateInput($apk_VersionCode,	125,  57, 300,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Input4 =	GUICtrlCreateInput($apk_PkgName,		125,  81, 300,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Input5 =	GUICtrlCreateInput($apk_MinSDK,			125, 105,  20,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Input6 =	GUICtrlCreateInput($sMinAndroidString,	150, 105, 275,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Input7 =	GUICtrlCreateInput($apk_TargetSDK,		125, 129,  20,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Input8 =	GUICtrlCreateInput($sTgtAndroidString,	150, 129, 275,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Input9 =	GUICtrlCreateInput($apk_Screens,		125, 153, 300,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Input10 =	GUICtrlCreateInput($apk_Densities,		125, 177, 300,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))

$Label5 = GUICtrlCreateLabel($String09,				 8,  208, 100,  20)
$Edit1 =  GUICtrlCreateEdit($apk_Permissions,		125, 205, 304,  85, BitOR($ES_READONLY,$ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$WS_VSCROLL,$ES_WANTRETURN))
$Label6 = GUICtrlCreateLabel($String10,				 8,  301, 100,  20)
$Edit2 =  GUICtrlCreateEdit($apk_Features,			125, 298, 304,  85, BitOR($ES_READONLY,$ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$WS_VSCROLL,$ES_WANTRETURN))

$gLabel7=	GUICtrlCreateLabel($String11,			 8,  404, 100,  20)
$Input11 =	GUICtrlCreateInput($fileAPK,			125, 401, 305,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$gLabel8=	GUICtrlCreateLabel($String12,			 8,  428, 100,  20)
$Input12 =	GUICtrlCreateInput($sNewFilenameAPK,	125, 425, 305,  20, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))

; Button pos 15 135 255 375
$gBtn_Eplorer =	GUICtrlCreateButton($String25,		15, 460, 110)
$gBtn_Play =	GUICtrlCreateButton($String13,		135, 460, 110)
$gBtn_Rename =	GUICtrlCreateButton($String14,		255, 460, 110)
$gBtn_Exit =	GUICtrlCreateButton($String15,		375, 460, 110)

_drawPNG()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $gBtn_Play
			_openPlay()

		Case $gBtn_Rename
			$sNewNameInput = InputBox($String16,$String17, $sNewFilenameAPK, "", 300, 130)
			If $ShowLog = "1" then
				IniWrite($Inidir & $IniLogReport, "NewFile", "NewFilenameAPK", $sNewFilenameAPK);
				IniWrite($Inidir & $IniLogReport, "NewFile", "NewNameInput", $sNewNameInput);
			Endif
			If $sNewNameInput <> "" Then _renameAPK($sNewNameInput)
		Case $gBtn_Exit
			_cleanUp()
			Exit
		Case $GUI_EVENT_CLOSE
			_cleanUp()
			Exit
		Case $gBtn_Eplorer
			_OpenNewFile()
			If $ShowLog="1" then
				IniWrite($Inidir & $IniLogReport, "OpenNewFile", "LastFileName", $fileAPK);
				IniWrite($Inidir & $IniLogReport, "OpenNewFile", "TempFileName", $tmp_Filename);
			Endif
			_drawPNG()
	EndSwitch
WEnd

;==================== End GUI =====================================

; Draw PNG image
Func MY_WM_PAINT($hWnd, $Msg, $wParam, $lParam)
    _WinAPI_RedrawWindow($hGUI, 0, 0, $RDW_UPDATENOW)
    _GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 440, 10)
    _WinAPI_RedrawWindow($hGUI, 0, 0, $RDW_VALIDATE)
    Return $GUI_RUNDEFMSG
EndFunc

Func _renameAPK($prmNewFilenameAPK)
	$result = FileMove($fullPathAPK, $dirAPK & "\" & $prmNewFilenameAPK)
	; if result<> = error
	If $result <> 1 Then MsgBox(0,$String18, $String19)
EndFunc

Func _SplitPath($prmFullPath, $prmReturnDir = false)
	$posSlash = StringInStr($prmFullPath, "\", 0, -1)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $posSlash = ' & $posSlash & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
	Switch $prmReturnDir
		Case False
			Return StringMid($prmFullPath, $posSlash + 1)
		Case True
			Return StringLeft($prmFullPath, $posSlash - 1)
	EndSwitch
EndFunc

Func _checkFileParameter($prmFilename)
	If FileExists($prmFilename) Then
		Return $prmFilename
	Else
		$f_Sel = FileOpenDialog($String20, $Lastfolder, "(*.apk)", 1, "")
		If @error Then Exit
		$Lastfolder = _SplitPath($f_Sel, true)
		IniWrite($Inidir & $IniProgramSettings, "Settings", "Lastfolder", $Lastfolder);
;		IniWrite($Inidir & $IniProgramSettings, "Settings", "Lastfile", $f_sel);
		Return $f_Sel
	EndIf
EndFunc

Func _OpenNewFile()
	$fullPathAPK = _checkFileParameter("")
	$dirAPK      = _SplitPath($fullPathAPK,true)
	$fileAPK     = _SplitPath($fullPathAPK,false)
	$tmp_Filename=""
	$tmpArrBadge = _getBadge($fullPathAPK)
	_parseLines($tmpArrBadge)
	_extractIcon($fullPathAPK, $apk_IconPath)

	If $apk_MinSDKVer <> "" Then $sMinAndroidString = 'Android ' & $apk_MinSDKVer  & ' (' & $apk_MinSDKName & ')'
	If $apk_TargetSDKVer <> "" Then $sTgtAndroidString = 'Android ' & $apk_TargetSDKVer  & ' (' & $apk_TargetSDKName & ')'

    $sNewFilenameAPK = StringReplace ($apk_Label, " ", " ") & $FileNamePrefix & StringReplace($apk_VersionName, " ", " ") & $FileNameSuffix & ".apk"

	GUICtrlSetData ($Input1 , $apk_Label)
	GUICtrlSetData ($Input2 , $apk_VersionName)
	GUICtrlSetData ($Input3 , $apk_VersionCode)
	GUICtrlSetData ($Input4 , $apk_PkgName)
	GUICtrlSetData ($Input5 , $apk_MinSDK	)
	GUICtrlSetData ($Input6 , $sMinAndroidString)
	GUICtrlSetData ($Input7 , $apk_TargetSDK)
	GUICtrlSetData ($Input8 , $sTgtAndroidString)
	GUICtrlSetData ($Input9 , $apk_Screens)
	GUICtrlSetData ($Input10, $apk_Densities)
	GUICtrlSetData ($Edit1  , $apk_Permissions)
	GUICtrlSetData ($Edit2  , $apk_Features)
	GUICtrlSetData ($input11, $fileAPK)
	GUICtrlSetData ($input12, $sNewFilenameAPK)
EndFunc

Func _getBadge($prmAPK)
	Local $foo = Run('aapt.exe d badging ' & '"' & $prmAPK & '"', @ScriptDir,  @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Local $output
	While 1
		$output &= StdoutRead($foo)
		If @error Then ExitLoop
	Wend
	$arrayLines = _StringExplode($output, @CRLF)
	Return $arrayLines
EndFunc

Func _parseLines($prmArrayLines)
	For $line in $prmArrayLines
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $line = ' & $line & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
		$arraySplit = _StringExplode($line, ":", 1)
		If Ubound($arraySplit) > 1 Then
			$key = $arraySplit[0]
			$value = $arraySplit[1]
		Else
			ContinueLoop
		EndIf

		Switch $key
			Case 'application'
				$tmp_arr =  _StringBetween($value, "label='", "'")
				$apk_Label = $tmp_arr[0]
				$tmp_arr =  _StringBetween($value, "icon='", "'")
				$apk_IconPath = $tmp_arr[0]
				$tmp_arr = _StringExplode($apk_IconPath, "/")
				$apk_IconName = $tmp_arr[UBound($tmp_arr)-1]

			Case 'package'
				$tmp_arr =  _StringBetween($value, "name='", "'")
				$apk_PkgName = $tmp_arr[0]
				$tmp_arr =  _StringBetween($value, "versionCode='", "'")
				$apk_VersionCode = $tmp_arr[0]
				$tmp_arr =  _StringBetween($value, "versionName='", "'")
				$apk_VersionName = $tmp_arr[0]

			Case 'uses-permission'
				$tmp_arr =  _StringBetween($value, "'", "'")
				$apk_Permissions &= StringLower(StringReplace($tmp_arr[0], "android.permission.", "")  & @CRLF)

			Case 'uses-feature'
				$tmp_arr =  _StringBetween($value, "'", "'")
				$apk_Features &= StringLower(StringReplace($tmp_arr[0], "android.hardware.", "")  & @CRLF)

			Case 'sdkVersion'
				$tmp_arr =  _StringBetween($value, "'", "'")
				$apk_MinSDK = $tmp_arr[0]
				$apk_MinSDKVer = _translateSDKLevel($apk_MinSDK)
				$apk_MinSDKName = _translateSDKLevel($apk_MinSDK, true)

			Case 'targetSdkVersion'
				$tmp_arr =  _StringBetween($value, "'", "'")
				$apk_TargetSDK = $tmp_arr[0]
				$apk_TargetSDKVer = _translateSDKLevel($apk_TargetSDK)
				$apk_TargetSDKName = _translateSDKLevel($apk_TargetSDK, true)

			Case 'supports-screens'
				$apk_Screens = StringStripWS(StringReplace($value, "'", ""),3)

			Case 'densities'
				$apk_Densities = StringStripWS(StringReplace($value, "'", ""),3)

			EndSwitch
	Next
EndFunc

Func _extractIcon($prmAPK, $prmIconPath)
	$runCmd = "unzip.exe -o -j " & '"' & $prmAPK & '" ' & $prmIconPath & " -d " & '"' & $tempPath & '"'
	RunWait($runCmd, @ScriptDir, @SW_HIDE)
EndFunc

Func _convertIcon($prmPNGPath)
	;not used
	$runCmd = 'convert.exe ' & '"' & $prmPNGPath & '"' & " -background #f0f0f0 -flatten -alpha off " & '"' & $tempPath & "\Icon.bmp" & '"'
	RunWait($runCmd, @ScriptDir, @SW_HIDE)
EndFunc

Func _cleanUp()
	FileDelete($tempPath)
	DirRemove($tempPath)
EndFunc

Func _openPlay()
	$url = $URLPlayStore & $apk_PkgName & '&hl=' & $PlayStoreLanguage
	ShellExecute($url)
EndFunc

Func _translateSDKLevel($prmSDKLevel, $prmReturnCodeName = false)
if $prmSDKLevel="1000" then
	$sVersion=$String21
	$sCodeName=$String22
Else
	$sVersion=Iniread ($Inidir & $IniGUISettings, "AndroidName", "SDK" & $prmSDKLevel & "-Version", $String23)
	$sCodeName=Iniread ($Inidir & $IniGUISettings, "AndroidName", "SDK" & $prmSDKLevel & "-CodeName", $String24)
Endif
	Switch $prmReturnCodeName
		Case true
			Return $sCodeName
		Case Else
			Return $sVersion
	EndSwitch
EndFunc

Func _drawPNG()
; Png Workaround
; Load PNG image
_GDIPlus_StartUp()
$hImage_original   = _GDIPlus_ImageLoadFromFile($tempPath & "\" & $apk_IconName)
If $ShowLog= "1" then
	IniWrite($Inidir & $IniLogReport, "Icon", "TempFilePath", $tempPath);
	IniWrite($Inidir & $IniLogReport, "Icon", "ApkIconeName", $apk_IconName);
Endif
	; resize always the bigger icon to 48x48 pixels
$hImage   = _GDIPlus_ImageResize ($hImage_original, 48, 48)
$type = VarGetType($hImage)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $type = ' & $type & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)

GUIRegisterMsg($WM_PAINT, "MY_WM_PAINT")

GUISetState(@SW_SHOW)

EndFunc
