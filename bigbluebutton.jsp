
<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Join Password</title>
</head>
<body>

<%@ include file="bbb_api.jsp"%>

<%

//
// We're going to define some sample courses (meetings) below.  This API exampe shows how you can create a login page for a course.
// The password below are not available to users as they are compiled on the server.
//

HashMap<String, HashMap> allMeetings = new HashMap<String, HashMap>();
HashMap<String, String> meeting;

// String welcome = "<br>Welcome to %%CONFNAME%%!<br><br>For help see our <a href=\"event:http://www.bigbluebutton.org/content/videos\"><u>tutorial videos</u></a>.<br><br>To join the voice bridge for this meeting:<br>  (1) click the hea$

String welcome = "<br>Welcome to <b>%%CONFNAME%%</b>!<br><br>To understand how BigBlueButton works see our <a href=\"event:http://www.bigbluebutton.org/content/videos\"><u>tutorial videos</u></a>.<br><br>To join the audio bridge click t$

//
// My courses
//

meeting = new HashMap<String, String>();
allMeetings.put( "Conference Room 1", meeting ); // The title that will appear in the drop-down menu
        meeting.put("welcomeMsg",       welcome);                       // The welcome mesage
        meeting.put("moderatorPW",      "password1");                        // The password for moderator
        meeting.put("viewerPW",         "password2");                        // The password for viewer
        meeting.put("voiceBridge",      "72013");                       // The extension number for the voice bridge (use if connected to phone system)
        meeting.put("logoutURL",        "/demo/demo3.jsp");  // The logout URL (use if you want to return to your pages)


meeting = new HashMap<String, String>();
allMeetings.put( "Conference Room 2", meeting );
        meeting.put("welcomeMsg",       welcome);                        // The welcome mesage
        meeting.put("moderatorPW",      "password1");                     // The password for moderator
        meeting.put("viewerPW",         "password2");                  // The password for viewer
        meeting.put("voiceBridge",      "72013");                       // The extension number for the voice bridge$
        meeting.put("logoutURL",        "/demo/demo3.jsp");  // The logout URL (use if you want to return to your pa$



Iterator<String> meetingIterator = new TreeSet<String>(allMeetings.keySet()).iterator();

if (request.getParameterMap().isEmpty()) {
                //
                // Assume we want to join a course
                //
        %>

<h2>Join (or create) a Session (password required)</h2>


<FORM NAME="form1" METHOD="GET">
<table cellpadding="5" cellspacing="5" style="width: 400px; ">
        <tbody>
                <tr>
                        <td>
                                &nbsp;</td>
                        <td style="text-align: right; ">
                                Full&nbsp;Name:</td>
                        <td style="width: 5px; ">
                                &nbsp;</td>
                        <td style="text-align: left ">
                                <input type="text" autofocus required name="username" /></td>
                </tr>



                <tr>
                        <td>
  				 &nbsp;</td>
                        <td style="text-align: right; ">
                                Full&nbsp;Name:</td>
                        <td style="width: 5px; ">
                                &nbsp;</td>
                        <td style="text-align: left ">
                                <input type="text" autofocus required name="username" /></td>
                </tr>



                <tr>
                        <td>
                                &nbsp;</td>
                        <td style="text-align: right; ">
                                Session:</td>
                        <td>
                                &nbsp;
                        </td>
                        <td style="text-align: left ">
                        <select name="meetingID">
                        <%
                                String key;
                                while (meetingIterator.hasNext()) {
                                        key = meetingIterator.next();
                                        out.println("<option value=\"" + key + "\">" + key + "</option>");
                                }
                        %>
                        </select>

                        </td>
                </tr>
                <tr>
                        <td>
                                &nbsp;</td>
                        <td style="text-align: right; ">
                                Password:</td>
                        <td>
                                &nbsp;</td>
                        <td>
                                <input type="password" required name="password" /></td>
 </tr>
                <tr>
                        <td>
                                &nbsp;</td>
                        <td>
                                &nbsp;</td>
                        <td>
                                &nbsp;</td>
                        <td>
                                <input type="submit" value="Join" /></td>
                </tr>
        </tbody>
</table>
<INPUT TYPE=hidden NAME=action VALUE="create">
</FORM>

Instructions:
<ul>
   Enter your name and the password you have been given to receive
   the apropriate privilages.

</ul>


<%
        } else if (request.getParameter("action").equals("create")) {
                //
                // Got an action=create
                //

                String username = request.getParameter("username");
                String meetingID = request.getParameter("meetingID");
                String password = request.getParameter("password");

                meeting = allMeetings.get( meetingID );

                String welcomeMsg = meeting.get( "welcomeMsg" );
                String logoutURL = meeting.get( "logoutURL" );
                Integer voiceBridge = Integer.parseInt( meeting.get( "voiceBridge" ).trim() );

                String viewerPW = meeting.get( "viewerPW" );
                String moderatorPW = meeting.get( "moderatorPW" );

                //
                // Check if we have a valid password
                //
                if ( ! password.equals(viewerPW) && ! password.equals(moderatorPW) ) {
%>

Invalid Password, please <a href="javascript:history.go(-1)">try again</a>.

<%
                        return;
                }

                //
                // Looks good, let's create the meeting
                //
                String meeting_ID = createMeeting( meetingID, welcomeMsg, moderatorPW, "Welcome moderator! (moderato$

                //
                // Check if we have an error.
                //
                if( meeting_ID.startsWith("Error ")) {
%>

Error: createMeeting() failed
<p /><%=meeting_ID%>


<%
                        return;
                }

                //
                // We've got a valid meeting_ID and passoword -- let's join!
                //

                String joinURL = getJoinMeetingURL(username, meeting_ID, password, null);
%>

<script language="javascript" type="text/javascript">
  window.location.href="<%=joinURL%>";
</script>

<%
        }
%>

<%@ include file="demo_footer.jsp"%>

</body>
</html>

