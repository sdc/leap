# Moodle 2 Web Services for Leap

This plugin contains the webservices required for integration between Moodle 2 and Leap, South Devon College's eILP (electronic individual learning plan) system. More info about Leap can be found at [leap-ilp.com](http://leap-ilp.com).

Web services for Leap already existed as they were written for our launch of Moodle 2.1, however they were added to core Moodle code in the first instance, and were becoming increasingly difficult to manage.

Now that Leap is being increasingly used in other colleges, the Moodle-Leap integration need to be seperated out, so now we have rewritten them as a seperate local Moodle plugin.

This local Moodle plugin has it's own repository located at [github.com/sdc/moodle-local_leapwebservices](https://github.com/sdc/moodle-local_leapwebservices), where bugs can be reported and issues raised.

## Files

Before installation, please check you have the following files and structure:

    leapwebservices/
    |-- db
    |   \-- services.php
    |-- externallib.php
    |-- lang
    |   \-- en
    |       \-- local_leapwebservices.php
    |-- pix
    |   \-- icon.png
    |-- readme.md
    \-- version.php


## Installation

* Copy the folder this readme is in into your Moodle's *local* folder
* Ensure the folder is named *leapwebservices* (removing any other text which may have appeared as part of the cloning or un-Zipping process)
* Log in to your Moodle site as an Administrator and visit the Notifications page
* The plugin should install without error. If you receive an error, please report it [here](https://github.com/sdc/moodle-local_leapwebservices/issues)
