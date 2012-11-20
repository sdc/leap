<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Leap Web Services template external functions and service definitions
 *
 * @package     local_leapwebservices
 * @copyright   2011 onwards Paul Vaughan, paulvaughan@southdevon.ac.uk
 * @license     http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

// We defined the web service functions to install.
$functions = array(

    'local_leapwebservices_get_users_by_username' => array(
        'classname'     => 'local_leapwebservices_external',
        'methodname'    => 'get_users_by_username',
        'classpath'     => 'local/leapwebservices/externallib.php',
        'description'   => 'Pass in username, get user details.',
        'type'          => 'read',
        'capabilities'  => 'moodle/user:viewalldetails',
    ),

    'local_leapwebservices_get_user_courses' => array(
        'classname'     => 'local_leapwebservices_external',
        'methodname'    => 'get_user_courses',
        'classpath'     => 'local/leapwebservices/externallib.php',
        'description'   => 'Return course details for a user.',
        'type'          => 'read',
        'capabilities'  => 'moodle/course:view,moodle/course:update,moodle/course:viewhiddencourses',
    ),

    'local_leapwebservices_get_courses_by_idnumber' => array(
        'classname'     => 'local_leapwebservices_external',
        'methodname'    => 'get_courses_by_idnumber',
        'classpath'     => 'local/leapwebservices/externallib.php',
        'description'   => 'Get course details for a given course idnumber.',
        'type'          => 'read',
        'capabilities'  => 'moodle/course:view,moodle/course:update,moodle/course:viewhiddencourses',
    ),

    'local_leapwebservices_get_assignments_by_username' => array(
        'classname'     => 'local_leapwebservices_external',
        'methodname'    => 'get_assignments_by_username',
        'classpath'     => 'local/leapwebservices/externallib.php',
        'description'   => 'Get assignment details for a given username',
        'type'          => 'read',
        'capabilities'  => 'moodle/user:viewdetails,moodle/user:viewalldetails,moodle/course:view,moodle/course:update',
    ),
);

// We define the services to install as pre-build services. A pre-build service is not editable by administrator.
$services = array(
    'Leap' => array(
        'functions' => array (
            'local_leapwebservices_get_users_by_username',
            'local_leapwebservices_get_user_courses',
            'local_leapwebservices_get_courses_by_idnumber',
            'local_leapwebservices_get_assignments_by_username',
        ),
        'restrictedusers'   => 1,
        'enabled'           => 1,
    )
);
