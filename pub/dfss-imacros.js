/*
 * Appoint car drive training automatically on
 *
 *     http://yueche.dfss.cn/web/cmp/login.aspx
 *
 * Usage:
 *
 * 1. Modify student_id and password below, set desired appointments
 * 2. Install iMacros for firefox from
 *    https://addons.mozilla.org/en-US/firefox/addon/3863
 * 3. Rec -> Load this script, rename to some name with ".js" extension
 * 4. Play
 */

var student_id = "nnnnnn";
var password = "xxxxx";

/*
 * Push disred day/time below in format "day/time"
 *
 *  day  - 0=Sunday, 1=Monday, 2=Tuesday, etc.
 *  time - one of "7-9", "9-13", 13-17" or "17-19"
 *
 * Example:
 *  appoints.push("0/13-17");       // Sunday 13-17
 *  appoints.push("1/9-13");        // Monday 9-13
 */
var appoints = new Array();

appoints.push("6/13-17");           // Saturday 13-17

var login_retry = 300;              // Each try takes about 1 second
var appoint_retry = 1000;


/**********************************************************************
 *
 * There should be nothing need to modify after this line.
 *
 **********************************************************************/

var LF = "\n";
var init_code = "CODE:SET !REPLAYSPEED FAST" + LF;

var macro_login = init_code;
macro_login += "SET !TIMEOUT 60" + LF;
macro_login += "URL GOTO=http://yueche.dfss.cn/web/cmp/login.aspx" + LF;
macro_login += "TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:form1 ATTR=ID:edtStudentID CONTENT=" + student_id + LF;
macro_login += "SET !ENCRYPTION NO" + LF;
macro_login += "TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:form1 ATTR=ID:edtPassword CONTENT=" + password + LF;
macro_login += "ONDIALOG POS=1 BUTTON=OK CONTENT=" + LF;
macro_login += "TAG POS=1 TYPE=INPUT:BUTTON FORM=ID:form1 ATTR=ID:btnSearch" + LF;

var macro_btnYC = init_code;
macro_btnYC += "SET !TIMEOUT 10" + LF;
macro_btnYC += "TAG POS=1 TYPE=INPUT:IMAGE FORM=ID:form1 ATTR=ID:btnYC" + LF;

var ret, i;

for (i = 0; i < login_retry; i++) {
   // Login.  There's a wait time TIMEOUT/10 seconds if login failed.
   //
   ret = iimPlay(macro_login);
   if (ret < 0) {
       err = iimGetLastError();
       iimDisplay(err);
       continue;
   }

   // Click button "Yue Che"
   //
   ret = iimPlay(macro_btnYC);
   if (ret < 0) {
       err = iimGetLastError();
       iimDisplay(err);
   }
   else {
       iimDisplay("Login succeed.");
       break;
   }

}
if (i >= login_retry) {
   alert("Login failed after " + login_retry + " retries, window will be closed.");
   window.close();
}


/*
 * day: 0-6, 0=Sunday
 * time: one of "7-9", "9-13", 13-17" and "17-19"
 */
function gen_tag_code(day, time)
{
   var today = new Date();
   var day_of_today = today.getDay();   // 0-6, 0=Sunday

   day_after = day - day_of_today;
   if (day_after < 0)
       day_after += 7;

   // Column (starts from 1):
   //      7-9   9-13   13-17   17-19
   var time_col = new Array();
   time_col["7-9"] = 1;
   time_col["9-13"] = 2;
   time_col["13-17"] = 3;
   time_col["17-19"] = 4;

   var col = time_col[time];
   var code = "TAG POS=1 TYPE=INPUT:IMAGE FORM=ID:form1 ATTR=ID:grid_grid_ci_0_" + col + "_" + day_after + "_imgButton";
   return code;
}

// Appoint
//
var flags = new Array(appoints.length);
var macros = new Array(appoints.length);
var k;

for (k = 0; k < appoints.length; k++) {
   var day = parseInt(appoints[k][0]);
   var time = appoints[k].slice(2);
   flags[k] = false;
   macros[k] = init_code;
   macros[k] += "SET !TIMEOUT 60" + LF;
   macros[k] += "ONDIALOG POS=1 BUTTON=CANCEL CONTENT=" + LF;
   macros[k] += gen_tag_code(day, time) + LF;
}

for (i = 0; i < appoint_retry; i++) {
   var all_appointed = true;
   for (k = 0; k < appoints.length; k++) {
       if (!flags[k]) {
           ret = iimPlay(macros[k]);
           if (ret < 0) {
               all_appointed = false;
               err = iimGetLastError();
               iimDisplay(err);
           }
           else {
               flags[k] = true;
               iimDisplay(appoints[k] + " appointed!");
           }
       }
   }

   if (all_appointed) {
       iimDisplay("All appointed!");
       break;
   }

   iimPlay("CODE:WAIT SECONDS=3\n");
   iimPlay("CODE:REFRESH\n");
}

if (i >= appoint_retry) {
   iimDisplay("Appoint failed after " + appoint_retry + " reties");
}
