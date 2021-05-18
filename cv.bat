0</*! ::
@echo off

if "%~1" == "--help" (
	cscript /nologo /e:javascript "%~f0"
	goto :EOF
)

timeout /t 0 >nul 2>&1
if errorlevel 1 (
	rem ... | cv
	cscript /nologo /e:javascript "%~f0" /CTRL:C
) else (
	rem cv | ...
	cscript /nologo /e:javascript "%~f0" /CTRL:V
)
goto :EOF */0;

switch ( ( WScript.Arguments.Named.Item("CTRL") || "" ).toUpperCase() ) {
case "C":
	clip(WScript.StdIn.ReadAll());
	break;
case "V":
	WScript.StdOut.Write(clip());
	break;
default:
	var me = WScript.ScriptName.replace(/\.[^.]+$/, "");
	WScript.StdOut.WriteLine("Usage [ " + me + " | ] ... [ | " + me + " ]");
	WScript.StdOut.WriteLine();
	WScript.StdOut.WriteLine("CTRL+C and CTRL+V in command line");
}

// This function was borrowed "as is" from my repo:
// https://github.com/ildar-shaimordanov/jsxt/blob/master/wsx/Helpers.js#L84-L129
function clip(text) {
	if ( typeof text == 'undefined' ) {
		return new ActiveXObject('htmlfile').parentWindow.clipboardData.getData('Text');
	}

	// Validate a value is integer in the range 1..100
	// Otherwise, defaults to 20
	var clamp = function(x) {
		x = Number(x);
		if ( isNaN(x) || x < 1 || x > 100 ) {
			x = 20;
		}
		return x;
	};

	var WAIT1 = clamp(clip.WAIT_READY);
	var WAIT2 = clamp(clip.WAIT_LOADED);

	// Borrowed from https://stackoverflow.com/a/16216602/3627676
	var msie = new ActiveXObject('InternetExplorer.Application');
	msie.silent = true;
	msie.Visible = false;
	msie.Navigate('about:blank');

	// Wait until MSIE ready
	while ( msie.ReadyState != 4 ) {
		WScript.Sleep(WAIT1);
	}

	// Wait until document loaded
	while ( msie.document.readyState != 'complete' ) {
		WScript.Sleep(WAIT2);
	}

	msie.document.body.innerHTML = '<textarea id="area" wrap="off" />';
	var area = msie.document.getElementById('area');
	area.value = text;
	area.select();
	area = null;

	// 12 - "Edit" menu, "Copy" command
	//  0 - the default behavior
	msie.ExecWB(12, 0);
	msie.Quit();
	msie = null;
}
