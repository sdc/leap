# Moodle 2 Web Services for Leap


## Introduction

This plugin contains the web services required for integration between [Moodle](http://moodle.org) 2 and [Leap](http://leap-ilp.com), South Devon College's ILP ( individual learning plan) system. More info about Leap can be found at [leap-ilp.com](http://leap-ilp.com).


## Purpose

Web services for Leap already existed as they were written for our launch of Moodle 2.1, however they were added to core Moodle code in the first instance, and were becoming increasingly difficult to manage.

Now that Leap is being increasingly used in other colleges, the Moodle-Leap integration need to be separated out, so now we have rewritten them as a separate local Moodle plugin.

This local Moodle plugin has it's own repository located at [github.com/sdc/moodle-local_leapwebservices](https://github.com/sdc/moodle-local_leapwebservices), where bugs can be reported and issues raised.

(**Note:** This plugin is only required if you are using Leap ILP from south Devon College. It has no use in any other circumstance. :)


## Moodle versions

This plugin has been written to work with South Devon College's currently-in-production version of Moodle, which at this time is 2.5. This plugin also works in Moodle 2.4 except the `get_users_by_username` function, which requires a function not found in Moodle 2.4 or earlier.

Earlier versions (2.0 to 2.3) have not been exhaustively tested with this plugin.


## Licence

Copyright &copy; 2011-2013 South Devon College.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.


## Files

Before installation, please check you have the following files and structure:

    leapwebservices/
    |-- db
    |   \-- services.php
    |-- externallib.php
    |-- gpl-3.0.txt
    |-- lang
    |   \-- en
    |       \-- local_leapwebservices.php
    |-- pix
    |   \-- icon.png
    |-- readme.md
    \-- version.php


## Installation

* Copy the folder containing this readme to your Moodle's **/local** folder
* Ensure the folder is named **leapwebservices** (removing any other text which may have appeared as part of the cloning or un-Zipping process)
* Log in to your Moodle site as an Administrator and visit the Notifications page
* The plugin should install without error. If you receive an error, please report it [here](https://github.com/sdc/moodle-local_leapwebservices/issues)


## Configuration

(**Note:** This guide has been written using Moodle 2.5. If you are using a different version of Moodle, your mileage may vary.)

This plugin has no configuration itself, however your Moodle installation will require configuration to correctly use web services. 

1.  Log in to your Moodle as administrator. Click on **Administration (block) &rarr; Site Administration &rarr; Plugins &rarr; Web services &rarr; Overview**.

    (**Note:** *This page shows an overview of Moodle's current web service configuration. You may wish to keep this page open, and open any links in a new tab or window, refreshing this page on your return.*)

2.  Click **1. Enable web services**. Check the box (a tick, cross or other identifying mark will appear, depending on your web browser) to turn web services on, then click **Save settings**. Return to the **Web services &rarr; Overview** screen.

    The overview screen should now show **yes** next to **1. Enable web services** in the **status** column.

3.  Click **2. Enable protocols**. Enable the **REST** protocol: click on the eye with the line through it, it will become **open**.  The other protocols are not required for the Leap web services, however **XML-RPC** is required for the older, unofficial Moodle mobile app and may already be turned on. This is fine: all the protocols can be turned on and won't affect each other, however it is a security concern to run unnecessary protocols, so turn off what you do not need.

    You may benefit from turning on **Web services documentation** (check the checkbox, click **Save settings**) but it is strongly advised to turn it off when it is no longer necessary.

    Return to the **Web services &rarr; Overview** screen. It should now show (at least) **REST** next to **2. Enable protocols** in the **status** column.

4.  A specific user is required to act as Moodle's avatar for incoming web services. You can have one user per web service, or one for all. Our setup uses a user called **Leap User** and it's profile picture is set accordingly.

    Click **3. Create a specific user**.  Create this "Leap user" as you see fit: give it a relevant username ("*leapuser*" in our case) and a **strong** password, as this user will have considerable control over core Moodle functions. 

5.  Create a new role ("web services") with appropriate protocol capabilities allowed (**webservice/rest:use**). Click on **Administration (block) &rarr; Site Administration &rarr; Users &rarr; Permissions &rarr; Define roles**, and click on **Add role**.

    Type in a relevant short (internal) name and a full (human readable) name, as well as a description (will only be seen by admins).  Ignore *Role archetype*. Check only the **system** check box. Search for and **allow** the following capabilities:

    **Web service: REST protocol**
    * webservice/rest:use (Use REST protocol)

    **System**
    * moodle/site:viewparticipants (View participants) 
    * moodle/user:update (Update user profiles)

    **Users**
    * moodle/user:viewalldetails (View user full information)

    **Course**
    * moodle/course:enrolreview (Review course enrolments)
    * moodle/course:movesections (Move sections)
    * moodle/course:update (Update course settings)
    * moodle/course:useremail (Enable/disable email address)
    * moodle/course:view (View courses without participation)
    * moodle/course:viewhiddencourses (View hidden courses)
    * moodle/course:viewparticipants (View participants)
    * moodle/role:review (Review permissions for others)
    * moodle/site:accessallgroups (Access all groups)
    * moodle/user:viewdetails (View user profiles)
    * moodle/user:viewhiddendetails (View hidden details of users)

    (**Note:** the best way is to use your web browser's search feature and search for the text exactly as it appears: it will get you to the exact capability or very close.)

6.  Assign the new *web services role* to the *web services user* as a system role: click on **Administration (block) &rarr; Site Administration &rarr; Users &rarr; Permissions &rarr; Assign system roles**.  Click on *webservices* (or whatever you have named your new role), then search in the box on the right for the new *Leap user*, then **add** the new user so the name appears in the box on the right.  It should be the only name in that box.  Return to the **Web services &rarr; Overview** screen.

7.  Click **4. Check user capability**.  Search for the user just created, then click on the name, then click **Show this user's permissions**.

    The results page should show the user as assigned to the *web service* role (what appears on-screen will be whatever you called the web service) and *authenticated user* in *system* context.

    Check that the list of capabilities in *5, above*, is set to **yes** (highlighted in green).  When done, return to the **Web services &rarr; Overview** screen.

8.  Click **5. Select a service**.  In the **Built-in services** section you should see an entry for *Leap*, and probably also an entry for the *Moodle mobile web service*, which will be greyed out if this is not turned on via the checkbox at the top of the page. (*Moodle mobile web services* are not required to be turned on for Leap web services to work.)

    Clicking on **Authorised users** next to *Leap* will show you a list of users authorised to use the Leap web services. It should show only the user you have assigned, but at the bottom of the page is a section titled **Change settings for the authorised users**: if there are any problems with the assigned user (lacking a particular context) they will be listed here in orange, and will need to be fixed before progressing further. Clicking on the user's name or email address will show some further security options, such as *IP restriction* (so a user can access the web service only from one or a range of IP addresses, blank by default) and a *Valid until* date when the access will cease (off by default). If you change any settings here, click **Update** to save them.

    Clicking the **Edit** button allows you to rename the web service (not recommended) and enable/disable the service. It is enabled as default.

    When done, return to the **Web services &rarr; Overview** screen.

9.  **6. Add functions** and **7. Select a specific user** have already been completed as part of **5. Select a service**, so ignore them. 

10. Click **8. Create a token for a user**.

    In the *Username / user id*  box, type in the exact username of the user created / selected in **step 4**, above.  This is a required field.

    (**Note:** For us, our authentication system [Shibboleth](http://shibboleth.net/) uses usernames in the form of an email address (e.g. username@example.com) but your system may be different and will most likely use only the *username* part.)

    Select *Leap* from the *Service* drop-down list, if it is not already chosen. (If you have Moodle mobile web services enabled, then they will appear also and I believe are the default option.) This is also a required option.

    If you wish, you may restrict the IP addresses from which the *Leap User* is allowed to log in from.  If you know, for example, that the computer/server with the address `172.100.100.1` is the only server which should be accessing Moodle, then put that IP address in the **IP Restriction** box. This way, if someone does find out the username and password for this user, they still won't be able to log in unless they also gain access to the server with that IP address.

    If you wish to restrict the date until which this user can log in with this token, check the **Enable** checkbox and set the date accordingly, either with the drop-down menus or by clicking on the date-picker menu icon.  Remember that you may always create another token for this user at any time, with a longer (or no) expiry: many can run concurrently.

    Click **Save changes** when done. You will be taken back to the **Manage tokens** screen, which will now show an alphanumeric token next to the name of your user. Your token will look something like *a180245560982a0e48e43577238c0198*. Treat this token like a password, keeping it secret and known only to those who absolutely need it, as anyone who has this token potentially has full access to all the webservices you selected earlier.

    (**Note:** This admin screen, and therefore the token, is available to anyone who is an *Administrator* on your Moodle.)

    When done, return to the **Web services &rarr; Overview** screen.

11. As mentioned earlier, you may benefit from turning on **Web services documentation** but it is strongly advised to turn it off when it is no longer necessary.

    Click **9. Enable developer documentation**, check the checkbox, then click **Save settings**. Documentation will only be shown for enabled protocols.

12. There are no built-in tests within Moodle which can test the Leap web service, only a handful of Moodle's own functions. The only way to test it is to add the token to an already-configured Leap system and test to see if a user's Moodle courses are being shown.

    Log in to your **Leap** installation as an administrative user.  Click on the **Admin** dropdiown menu at the top on the right, next to your name. If you cannot see this menu, you do not have administrative rights on your Leap installation.  Select **Settings**.
    
    Scroll down the screen until you see a section called **Old settings**. (This may change in the future as the settings aspect of Leap is improved.)  Find a field called **Moodle token** and paste into this field the token Moodle generated in step 10, above.
    
    Scroll down and click *Save changes*.
    
    Accessing any student's information on Leap should now also show all courses they are enrolled on in Moodle.

    **Note:** If you experience problems with any of the above steps, please contact us via the contact options on [leap-ilp.com](http://leap-ilp.com) or by [opening an issue here on GitHub](https://github.com/sdc/moodle-local_leapwebservices/issues).


## Using the web services

Here is a brief guide to how to access the web services via a web browser. The query is always passed as a correctly-formatted URL, and the response is always given as XML.


### `get_user_courses`

* Pass: a user's username.
* Returns: a list of courses the user is enrolled on:
    * id - the course id
    * shortname - the course's short name
    * fullname - the course's full name
    * idnumber - the idnumber of the course (if given)
    * visible - 1 for visible, 0 for hidden
    * canedit - 1 if the specified user has editing rights to this course, 0 if not

Use a URL with the following format:

`http://yourmoodle.com/webservice/rest/server.php?wstoken=YOURTOKEN&wsfunction=local_leapwebservices_get_user_courses&username=USERNAME`

...where *YOURTOKEN* is the token created within Moodle, and *USERNAME* is the username of the Moodle user you are querying, e.g.:

`http://yourmoodle.com/webservice/rest/server.php?wstoken=a180245560982a0e48e43577238c0198&wsfunction=local_leapwebservices_get_user_courses&username=paulvaughan`

The above query should return the following data structure (data for example purposes only):

    <?xml version="1.0" encoding="UTF-8" ?>
    <RESPONSE>
      <MULTIPLE>
        <SINGLE>
          <KEY name="id">
            <VALUE>1234</VALUE>
          </KEY>
          <KEY name="shortname">
            <VALUE>MuTech</VALUE>
          </KEY>
          <KEY name="fullname">
            <VALUE>Music Technology</VALUE>
          </KEY>
          <KEY name="idnumber">
            <VALUE>MT001</VALUE>
          </KEY>
          <KEY name="visible">
            <VALUE>1</VALUE>
          </KEY>
          <KEY name="canedit">
            <VALUE>1</VALUE>
          </KEY>
        </SINGLE>
        <SINGLE>
          <KEY name="id">
            <VALUE>4096</VALUE>
          </KEY>
          <KEY name="shortname">
            <VALUE>SysA</VALUE>
          </KEY>
          <KEY name="fullname">
            <VALUE>Systems Analysis</VALUE>
          </KEY>
          <KEY name="idnumber">
            <VALUE></VALUE>
          </KEY>
          <KEY name="visible">
            <VALUE>1</VALUE>
          </KEY>
          <KEY name="canedit">
            <VALUE>0</VALUE>
          </KEY>
        </SINGLE>
      </MULTIPLE>
    </RESPONSE>

**Note:** The `<SINGLE>` element will appear as many times as there are courses *USERNAME* is enrolled on.


### `get_courses_by_idnumber`

* Pass: a course's idnumber (not to be confused with a course's id).
* Returns: a list of courses the user is enrolled on (including but not limited to):
    * id - the course id
    * shortname - the course's short name
    * categoryid - the id of the category the course is in
    * fullname - the course's full name
    * idnumber - the idnumber of the course (slightly redundant, but may be slightly different to that passed in)
    * summary - a summary of the course
    * format - the course's format (e.g. topics, weeks, grid)
    * startdate - the start date, in Unix epoch format
    * visible - 1 for visible, 0 for hidden

Use a URL with the following format:

`http://yourmoodle.com/webservice/rest/server.php?wstoken=YOURTOKEN&wsfunction=local_leapwebservices_get_courses_by_idnumber&idnumber=IDNUMBER`

...where *YOURTOKEN* is the token created within Moodle, and *IDNUMBER* is in a course's `idnumber` field, e.g.:

`http://yourmoodle.com/webservice/rest/server.php?wstoken=a180245560982a0e48e43577238c0198&wsfunction=local_leapwebservices_get_courses_by_idnumber&idnumber=paulscourse1234`

The above query should return the following data structure (data for example purposes only):

    <?xml version="1.0" encoding="UTF-8" ?>
    <RESPONSE>
      <MULTIPLE>
        <SINGLE>
          <KEY name="id">
            <VALUE>1234</VALUE>
          </KEY>
          <KEY name="shortname">
            <VALUE>MuTech</VALUE>
          </KEY>
          <KEY name="categoryid">
            <VALUE>123</VALUE>
          </KEY>
          <KEY name="categorysortorder">
            <VALUE>12345</VALUE>
          </KEY>
          <KEY name="fullname">
            <VALUE>Music Technology</VALUE>
          </KEY>
          <KEY name="idnumber">
            <VALUE>MT001</VALUE>
          </KEY>
          <KEY name="summary">
            <VALUE>From 8-tracks to 24bit, 96kHz recording, we have the lot.</VALUE>
          </KEY>
          <KEY name="summaryformat">
            <VALUE>1</VALUE>
          </KEY>
          <KEY name="format">
            <VALUE>topics</VALUE>
          </KEY>
          <KEY name="showgrades">
            <VALUE>1</VALUE>
          </KEY>
          <KEY name="newsitems">
            <VALUE>8</VALUE>
          </KEY>
          <KEY name="startdate">
            <VALUE>1388534400</VALUE>
          </KEY>
          <KEY name="maxbytes">
            <VALUE>10485760</VALUE>
          </KEY>
          <KEY name="showreports">
            <VALUE>0</VALUE>
          </KEY>
          <KEY name="visible">
            <VALUE>1</VALUE>
          </KEY>
          <KEY name="groupmode">
            <VALUE>0</VALUE>
          </KEY>
          <KEY name="groupmodeforce">
            <VALUE>0</VALUE>
          </KEY>
          <KEY name="defaultgroupingid">
            <VALUE>0</VALUE>
          </KEY>
          <KEY name="timecreated">
            <VALUE>1356998400</VALUE>
          </KEY>
          <KEY name="timemodified">
            <VALUE>1356998403</VALUE>
          </KEY>
          <KEY name="enablecompletion">
            <VALUE>0</VALUE>
          </KEY>
          <KEY name="completionnotify">
            <VALUE>0</VALUE>
          </KEY>
          <KEY name="lang">
            <VALUE></VALUE>
          </KEY>
          <KEY name="forcetheme">
            <VALUE></VALUE>
          </KEY>
        </SINGLE>
      </MULTIPLE>
    </RESPONSE>

**Note:** The `<SINGLE>` element will appear as many times as there are courses which have *IDNUMBER* in the `idnumber` field.


### `get_users_by_username`

**Note:** this function will only work with Moodle 2.5 or later. Calling this function with Moodle 2.4 or earlier will result in an exception being thrown.

* Pass: one or more usernames.
* Returns: a list of user details:
    * id - the user's id
    * username - the user's username (slightly redundant)
    * firstname - the user's first name
    * lastname - the user's last name
    * email - the user's email address
    (There is potential for considerably more detail to be returned.)

Use a URL with the following format:

`http://yourmoodle.com/webservice/rest/server.php?wstoken=YOURTOKEN&wsfunction=local_leapwebservices_get_users_by_username&usernames[]=USERNAME&usernames[]=USERNAME&usernames[]=USERNAME`

...where *YOURTOKEN* is the token created within Moodle, and **each** *USERNAME* is a different user's username, e.g.:

`http://yourmoodle.com/webservice/rest/server.php?wstoken=a180245560982a0e48e43577238c0198&wsfunction=local_leapwebservices_get_users_by_username&usernames[]=paulvaughan&usernames[]=kevinhughes&usernames[]=greypoupon`

**Note:** You may add as many `&usernames[]=USERNAME` structures to the URL as you require, but keep it sensible.

The above query should return the following data structure (data for example purposes only):

    <?xml version="1.0" encoding="UTF-8" ?>
    <RESPONSE>
      <MULTIPLE>
        <SINGLE>
          <KEY name="id">
            <VALUE>2</VALUE>
          </KEY>
          <KEY name="username">
            <VALUE>paulvaughan</VALUE>
          </KEY>
          <KEY name="firstname">
            <VALUE>Paul</VALUE>
          </KEY>
          <KEY name="lastname">
            <VALUE>Vaughan</VALUE>
          </KEY>
          <KEY name="email">
            <VALUE>paulvaughan@example.ac.uk</VALUE>
          </KEY>
        </SINGLE>
        <SINGLE>
          <KEY name="id">
            <VALUE>27</VALUE>
          </KEY>
          <KEY name="username">
            <VALUE>kevinhughes</VALUE>
          </KEY>
          <KEY name="firstname">
            <VALUE>Kevin</VALUE>
          </KEY>
          <KEY name="lastname">
            <VALUE>Hughes</VALUE>
          </KEY>
          <KEY name="email">
            <VALUE>kevinhughes@example.ac.uk</VALUE>
          </KEY>
        </SINGLE>
        <SINGLE>
          <KEY name="id">
            <VALUE>101</VALUE>
          </KEY>
          <KEY name="username">
            <VALUE>greypoupon</VALUE>
          </KEY>
          <KEY name="firstname">
            <VALUE>Grey</VALUE>
          </KEY>
          <KEY name="lastname">
            <VALUE>Poupon</VALUE>
          </KEY>
          <KEY name="email">
            <VALUE>greypoupon@example.ac.uk</VALUE>
          </KEY>
        </SINGLE>
      </MULTIPLE>
    </RESPONSE>

**Note:** The `<SINGLE>` element will appear as many times as USERNAME was supplied in the URL.


### `get_assignments_by_username`

* Pass: a user's username.
* Returns: a list of assignments:
    * id - the assignment's id
    * name - the assignment's name
    * intro - the assignment's introductory text (stripped of HTML tags)
    * allowsubmissionsfromdate - the date and time at which submissions can be made from, in Unix epoch format
    * allowsubmissionsfromdate-kev - same as above but in ISO 8601 format
    * duedate - the date and time at which submissions can no longer be made, in Unix epoch format
    * duedate-kev - same as above but in ISO 8601 format
    * course - the id of the course the assignment is in
    * instance - the assignment's instance id

Use a URL with the following format:

`http://yourmoodle.com/webservice/rest/server.php?wstoken=YOURTOKEN&wsfunction=local_leapwebservices_get_assignments_by_username&username=USERNAME`

...where *YOURTOKEN* is the token created within Moodle, and *USERNAME* is a user's username, e.g.:

`http://yourmoodle.com/webservice/rest/server.php?wstoken=a180245560982a0e48e43577238c0198&wsfunction=local_leapwebservices_get_assignments_by_username&username=paulvaughan`

The above query should return the following data structure (data for example purposes only):

    <?xml version="1.0" encoding="UTF-8" ?>
    <RESPONSE>
      <MULTIPLE>
        <SINGLE>
          <KEY name="id">
            <VALUE>123</VALUE>
          </KEY>
          <KEY name="name">
            <VALUE>December Assignment</VALUE>
          </KEY>
          <KEY name="intro">
            <VALUE>This is going to be the best assignment about December ever.</VALUE>
          </KEY>
          <KEY name="allowsubmissionsfromdate">
            <VALUE>1388534400</VALUE>
          </KEY>
          <KEY name="allowsubmissionsfromdate-kev">
            <VALUE>2014-01-01T00:00:00+00:00</VALUE>
          </KEY>
          <KEY name="duedate">
            <VALUE>1388534401</VALUE>
          </KEY>
          <KEY name="duedate-kev">
            <VALUE>2014-01-01T00:00:01+00:00</VALUE>
          </KEY>
          <KEY name="course">
            <VALUE>123</VALUE>
          </KEY>
          <KEY name="instance">
            <VALUE>12345</VALUE>
          </KEY>
        </SINGLE>
      </MULTIPLE>
    </RESPONSE>

**Note:** The `<SINGLE>` element will appear as many times as there are assignments assigned to *USERNAME*.

 
## History

* 2013-12-05, v0.3.5: Fixed the 'get_assignments_by_username' webservice to use newer 'assign' rather than older 'assignments' system; wrote API documentation; version bump.
* 2013-12-05, v0.3.4: Fixed the 'get_users_by_username' webservice for Moodle 2.5 or greater only; wrote API documentation; version bump.
* 2013-12-02, v0.3.3: Removed hardcoded mdl_ table prefixes and version bump.
* 2013-11-29, v0.3.2: Version bump and minor code changes to test at Merthyr.
* 2013-11-27, v0.3.1: Documentation changes only: how to configure Moodle to use web services. No code changes.
* 2013-08-30, v0.3.1: Removed Moodle user table fields which no longer exist, preventing stack traces in the Moodle/Apache logs.
* 2013-05-24, v0.3: Minor update as the mdl_course table has had some columns re/moved elsewhere in Moodle 2.5.
* 2012-11-20, v0.2: Initial release of the plugin.
