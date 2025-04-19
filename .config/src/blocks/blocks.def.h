//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{" 󰌌 ", "xkb-switch -p | sed 's/\(.*\)[(|(].*/\1/'",				                            0,		1},

	{"󰕾 ", "pamixer --get-volume-human | sed 's/%//'",				0,		2},

	{" ", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",   5,		0},

	{"󰥔 ", "date '+%b %d (%a) %I:%M:%S%p' ",					       1,		0},

};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
// static char delim[] = "^c#ebdbb2^ | ";
static char delim[] = "   ";
static unsigned int delimLen = 30;
