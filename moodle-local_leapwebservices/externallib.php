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
 * Leap Web Services external web services template
 *
 * @package     local_leapwebservices
 * @copyright   2011 onwards Paul Vaughan, paulvaughan@southdevon.ac.uk
 * @license     http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

require_once($CFG->libdir.'/externallib.php');

/**
 * External Webservices API class
 * @copyright   2011 onwards Paul Vaughan, paulvaughan@southdevon.ac.uk
 * @license     http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class local_leapwebservices_external extends external_api {

    /**
     * The below three functions started off as duplicates of:
     *      get_courses_parameters
     *      get_courses
     *      get_courses_returns
     * ...modified to use the username field instead, but created as stand-alone web services.
     */

    /**
     * Returns description of method parameters
     * @return external_function_parameters
     */
    public static function get_user_courses_parameters() {
        return new external_function_parameters(
            array(
                'username' => new external_value(PARAM_TEXT, 'Username of user. If empty, fail.'),
            )
        );
    }

    /**
     * Get user courses
     * @param array $username
     * @return array
     */
    public static function get_user_courses($username) {
        global $CFG, $DB;
        require_once($CFG->dirroot . "/course/lib.php");

        $params = self::validate_parameters(self::get_user_courses_parameters(),
            array('username' => $username));

        if ($params['username'] == '') {
            header($_SERVER["SERVER_PROTOCOL"].' 422 Unprocessable Entity ($params[\'username\'] empty.)', true, 422);
        }

        $courses = $DB->get_records_sql("SELECT DISTINCT c.id AS id, c.fullname, c.shortname, c.idnumber, c.visible
            FROM mdl_role_assignments ra, mdl_user u, mdl_course c, mdl_context cxt, mdl_role r
            WHERE ra.userid = u.id
            AND ra.contextid = cxt.id
            AND cxt.contextlevel = 50
            AND cxt.instanceid = c.id
            AND ra.roleid = r.id
            AND u.username =  '".$params['username']."'
            ORDER BY fullname ASC;");

        $coursesinfo = array();
        foreach ($courses as $course) {
            $context = get_context_instance(CONTEXT_COURSE, $course->id);
            try {
                self::validate_context($context);
            } catch (Exception $e) {
                $exceptionparam             = new stdClass();
                $exceptionparam->message    = $e->getMessage();
                $exceptionparam->courseid   = $course->id;
                throw new moodle_exception(
                    get_string('errorcoursecontextnotvalid', 'webservice', $exceptionparam));
            }
            require_capability('moodle/course:view', $context);

            $courseinfo = array();
            $courseinfo['id']           = $course->id;
            $courseinfo['shortname']    = $course->shortname;
            $courseinfo['fullname']     = $course->fullname;
            $courseinfo['idnumber']     = $course->idnumber;
            $courseinfo['visible']      = $course->visible;

            $user = $DB->get_record('user', array('username' => $params['username']));
            $context = get_context_instance(CONTEXT_COURSE, $course->id);
            $courseinfo['canedit'] = has_capability('moodle/course:update', $context, $user->id) ? 1 : 0;

            $coursesinfo[] = $courseinfo;
        }

        return $coursesinfo;
    }

    /**
     * Returns description of method result value
     * @return external_description
     */
    public static function get_user_courses_returns() {
        return new external_multiple_structure(
            new external_single_structure(
                array(
                    'id'            => new external_value(PARAM_INT, 'course id'),
                    'shortname'     => new external_value(PARAM_TEXT, 'course short name'),
                    'fullname'      => new external_value(PARAM_TEXT, 'full name'),
                    'idnumber'      => new external_value(PARAM_RAW, 'id number'),
                    'visible'       => new external_value(PARAM_INT, '1: available to student, 0: not available'),
                    'canedit'       => new external_value(PARAM_BOOL, '1: user can edit the course, 0: user cannot edit the course'),
                ), 'course'
            )
        );
    }

    /**
     * The below three functions again started off as duplicates of:
     *      get_courses_parameters
     *      get_courses
     *      get_courses_returns
     * ...modified to use the idnumber field instead, but created as stand-alone web services.
     */

    /**
     * Returns description of method parameters
     * @return external_function_parameters
     */
    public static function get_courses_by_idnumber_parameters() {
        return new external_function_parameters(
            array(
                'idnumber' => new external_value(PARAM_TEXT, 'idnumber of course. If empty, fail.'),
            )
        );
    }

    /**
     * Get courses by idnumber
     * @param string $idnumber
     * @return array
     */
    public static function get_courses_by_idnumber($idnumber) {
        global $CFG, $DB;
        require_once($CFG->dirroot . "/course/lib.php");

        $params = self::validate_parameters(self::get_courses_by_idnumber_parameters(), array('idnumber' => $idnumber));

        if ($params['idnumber'] == '') {
            header($_SERVER["SERVER_PROTOCOL"].' 422 Unprocessable Entity ($params[\'idnumber\'] empty.)', true, 422);
        }

        $courses = $DB->get_records_select('course', 'idnumber LIKE "%|'.$idnumber.'|%"', null, 'id', '*', null, null);

        $coursesinfo = array();
        foreach ($courses as $course) {
            $context = get_context_instance(CONTEXT_COURSE, $course->id);
            try {
                self::validate_context($context);
            } catch (Exception $e) {
                $exceptionparam             = new stdClass();
                $exceptionparam->message    = $e->getMessage();
                $exceptionparam->courseid   = $course->id;
                throw new moodle_exception(
                        get_string('errorcoursecontextnotvalid', 'webservice', $exceptionparam));
            }
            require_capability('moodle/course:view', $context);

            $courseinfo = array();
            $courseinfo['id']                       = $course->id;
            $courseinfo['fullname']                 = $course->fullname;
            $courseinfo['shortname']                = $course->shortname;
            $courseinfo['categoryid']               = $course->category;
            $courseinfo['summary']                  = $course->summary;
            $courseinfo['summaryformat']            = $course->summaryformat;
            $courseinfo['format']                   = $course->format;
            $courseinfo['startdate']                = $course->startdate;
            $courseinfo['numsections']              = $course->numsections;

            $courseadmin = has_capability('moodle/course:update', $context);
            if ($courseadmin) {
                $courseinfo['categorysortorder']        = $course->sortorder;
                $courseinfo['idnumber']                 = $course->idnumber;
                $courseinfo['showgrades']               = $course->showgrades;
                $courseinfo['showreports']              = $course->showreports;
                $courseinfo['newsitems']                = $course->newsitems;
                $courseinfo['visible']                  = $course->visible;
                $courseinfo['maxbytes']                 = $course->maxbytes;
                $courseinfo['hiddensections']           = $course->hiddensections;
                $courseinfo['groupmode']                = $course->groupmode;
                $courseinfo['groupmodeforce']           = $course->groupmodeforce;
                $courseinfo['defaultgroupingid']        = $course->defaultgroupingid;
                $courseinfo['lang']                     = $course->lang;
                $courseinfo['timecreated']              = $course->timecreated;
                $courseinfo['timemodified']             = $course->timemodified;
                $courseinfo['forcetheme']               = $course->theme;
                $courseinfo['enablecompletion']         = $course->enablecompletion;
                $courseinfo['completionstartonenrol']   = $course->completionstartonenrol;
                $courseinfo['completionnotify']         = $course->completionnotify;
            }

            if ($courseadmin or $course->visible
                    or has_capability('moodle/course:viewhiddencourses', $context)) {
                $coursesinfo[] = $courseinfo;
            }
        }

        return $coursesinfo;
    }

    /**
     * Returns description of method result value
     * @return external_description
     */
    public static function get_courses_by_idnumber_returns() {
        return new external_multiple_structure(
            new external_single_structure(
                array(
                    'id' => new external_value(PARAM_INT, 'course id'),
                    'shortname' => new external_value(PARAM_TEXT, 'course short name'),
                    'categoryid' => new external_value(PARAM_INT, 'category id'),
                    'categorysortorder' => new external_value(PARAM_INT, 'sort order into the category', VALUE_OPTIONAL),
                    'fullname' => new external_value(PARAM_TEXT, 'full name'),
                    'idnumber' => new external_value(PARAM_RAW, 'id number', VALUE_OPTIONAL),
                    'summary' => new external_value(PARAM_RAW, 'summary'),
                    'summaryformat' => new external_value(PARAM_INT,
                            'the summary text Moodle format'),
                    'format' => new external_value(PARAM_ALPHANUMEXT,
                            'course format: weeks, topics, social, site,..'),
                    'showgrades' => new external_value(PARAM_INT,
                            '1 if grades are shown, otherwise 0', VALUE_OPTIONAL),
                    'newsitems' => new external_value(PARAM_INT,
                            'number of recent items appearing on the course page', VALUE_OPTIONAL),
                    'startdate' => new external_value(PARAM_INT,
                            'timestamp when the course start'),
                    'numsections' => new external_value(PARAM_INT, 'number of weeks/topics'),
                    'maxbytes' => new external_value(PARAM_INT,
                            'largest size of file that can be uploaded into the course', VALUE_OPTIONAL),
                    'showreports' => new external_value(PARAM_INT,
                            'are activity report shown (yes = 1, no =0)', VALUE_OPTIONAL),
                    'visible' => new external_value(PARAM_INT,
                            '1: available to student, 0:not available', VALUE_OPTIONAL),
                    'hiddensections' => new external_value(PARAM_INT,
                            'How the hidden sections in the course are displayed to students', VALUE_OPTIONAL),
                    'groupmode' => new external_value(PARAM_INT, 'no group, separate, visible', VALUE_OPTIONAL),
                    'groupmodeforce' => new external_value(PARAM_INT, '1: yes, 0: no', VALUE_OPTIONAL),
                    'defaultgroupingid' => new external_value(PARAM_INT, 'default grouping id', VALUE_OPTIONAL),
                    'timecreated' => new external_value(PARAM_INT,
                            'timestamp when the course have been created', VALUE_OPTIONAL),
                    'timemodified' => new external_value(PARAM_INT,
                            'timestamp when the course have been modified', VALUE_OPTIONAL),
                    'enablecompletion' => new external_value(PARAM_INT,
                            'Enabled, control via completion and activity settings. Disbaled,
                                not shown in activity settings.', VALUE_OPTIONAL),
                    'completionstartonenrol' => new external_value(PARAM_INT,
                            '1: begin tracking a student\'s progress in course completion
                                after course enrolment. 0: does not', VALUE_OPTIONAL),
                    'completionnotify' => new external_value(PARAM_INT,
                            '1: yes 0: no', VALUE_OPTIONAL),
                    'lang' => new external_value(PARAM_ALPHANUMEXT,
                            'forced course language', VALUE_OPTIONAL),
                    'forcetheme' => new external_value(PARAM_ALPHANUMEXT,
                            'name of the force theme', VALUE_OPTIONAL),
                ), 'course'
            )
        );
    }


    /**
     * The below three functions are duplicates of
     *      get_users_by_id_parameters
     *      get_users_by_id
     *      get_users_by_id_returns
     * ...modified to use the username field instead, but created as stand-alone web services.
     */

    /**
     * Returns description of method parameters
     * @return external_function_parameters
     */
    public static function get_users_by_username_parameters() {
        return new external_function_parameters(
                array(
                    'usernames' => new external_multiple_structure(new external_value(PARAM_RAW, 'username')),
                )
        );
    }

    /**
     * Get user information
     *
     * @param array $usernames  array of user ids
     * @return array An array of arrays describing users
     */
    public static function get_users_by_username($usernames) {
        global $CFG;
        require_once($CFG->dirroot . "/user/lib.php");
        require_once($CFG->dirroot . "/user/profile/lib.php");

        $params = self::validate_parameters(self::get_users_by_username_parameters(),
                array('usernames'=>$usernames));

        $users = user_get_users_by_username($params['usernames']);
        $result = array();
        foreach ($users as $user) {

            $context = get_context_instance(CONTEXT_USER, $user->id);
            require_capability('moodle/user:viewalldetails', $context);
            self::validate_context($context);

            if (empty($user->deleted)) {

                $userarray = array();
                $userarray['id']                    = $user->id;
                $userarray['username']              = $user->username;
                $userarray['firstname']             = $user->firstname;
                $userarray['lastname']              = $user->lastname;
                $userarray['email']                 = $user->email;
                $userarray['auth']                  = $user->auth;
                $userarray['confirmed']             = $user->confirmed;
                $userarray['idnumber']              = $user->idnumber;
                $userarray['lang']                  = $user->lang;
                $userarray['theme']                 = $user->theme;
                $userarray['timezone']              = $user->timezone;
                $userarray['mailformat']            = $user->mailformat;
                $userarray['description']           = $user->description;
                $userarray['descriptionformat']     = $user->descriptionformat;
                $userarray['city']                  = $user->city;
                $userarray['country']               = $user->country;
                $userarray['customfields']          = array();
                $customfields                       = profile_user_record($user->id);
                $customfields                       = (array) $customfields;
                foreach ($customfields as $key => $value) {
                    $userarray['customfields'][] = array('type' => $key, 'value' => $value);
                }

                $result[] = $userarray;
            }
        }

        return $result;
    }

    /**
     * Returns description of method result value
     * @return external_description
     */
    public static function get_users_by_username_returns() {
        return new external_multiple_structure(
            new external_single_structure(
                array(
                    'id'                    => new external_value(PARAM_NUMBER, 'ID of the user'),
                    'username'              => new external_value(PARAM_RAW, 'Username policy is defined in Moodle security config'),
                    'firstname'             => new external_value(PARAM_NOTAGS, 'The first name(s) of the user'),
                    'lastname'              => new external_value(PARAM_NOTAGS, 'The family name of the user'),
                    'email'                 => new external_value(PARAM_TEXT, 'An email address - allow email as root@localhost'),
                    'auth'                  => new external_value(PARAM_SAFEDIR, 'Auth plugins include manual, ldap, imap, etc'),
                    'confirmed'             => new external_value(PARAM_NUMBER, 'Active user: 1 if confirmed, 0 otherwise'),
                    'idnumber'              => new external_value(PARAM_RAW, 'An arbitrary ID code number perhaps from the institution'),
                    'lang'                  => new external_value(PARAM_SAFEDIR, 'Language code such as "en", must exist on server'),
                    'theme'                 => new external_value(PARAM_SAFEDIR, 'Theme name such as "standard", must exist on server'),
                    'timezone'              => new external_value(PARAM_ALPHANUMEXT, 'Timezone code such as Australia/Perth, or 99 for default'),
                    'mailformat'            => new external_value(PARAM_INTEGER, 'Mail format code is 0 for plain text, 1 for HTML etc'),
                    'description'           => new external_value(PARAM_RAW, 'User profile description'),
                    'descriptionformat'     => new external_value(PARAM_INT, 'User profile description format'),
                    'city'                  => new external_value(PARAM_NOTAGS, 'Home city of the user'),
                    'country'               => new external_value(PARAM_ALPHA, 'Home country code of the user, such as AU or CZ'),
                    'customfields'          => new external_multiple_structure(
                        new external_single_structure(
                            array(
                                'type'  => new external_value(PARAM_ALPHANUMEXT, 'The name of the custom field'),
                                'value' => new external_value(PARAM_RAW, 'The value of the custom field')
                            )
                        ),
                    'User custom fields (also known as user profile fields)',
                    VALUE_OPTIONAL
                    )
                )
            )
        );
    }

    /**
     * The below three functions are duplicates of
     * get_users_by_id_parameters
     * get_users_by_id
     * get_users_by_id_returns
     * ...modified to use the username field instead, but created as stand-alone web services.
     */

    /**
     * Returns description of method parameters
     * @return external_function_parameters
     */
    public static function get_assignments_by_username_parameters() {
        return new external_function_parameters(
            array(
                'username' => new external_value(PARAM_TEXT, 'Username. If empty, fail.'),
            )
        );
    }

    /**
     * Get user information
     *
     * @param array $username array of user ids
     * @return array An array of arrays describing users
     */
    public static function get_assignments_by_username($username) {
        global $CFG, $DB;

        $params = self::validate_parameters(self::get_assignments_by_username_parameters(), array('username' => $username));

        if ($params['username'] == '') {
            header($_SERVER["SERVER_PROTOCOL"].' 422 Unprocessable Entity ($params[\'username\'] empty.)', true, 422);
            exit;
        }

        $user = $DB->get_record('user', array('username' => $params['username']));
        $courses = enrol_get_users_courses($user->id, false, '*');
        if (!empty($courses)) {

            $contents = array();
            foreach ($courses as $course) {
                $contents[] = $DB->get_records('assignment', array('course' => $course->id), 'timedue ASC', 'id, name, intro, timeavailable, timedue, course');
            }

            $result = array();
            foreach ($contents as $morecontents) {
                foreach ($morecontents as $content) {
                    $assarray = array();
                    $assarray['id']                     = $content->id;
                    $assarray['name']                   = $content->name;
                    $assarray['intro']                  = $content->intro;
                    $assarray['timeavailable']          = $content->timeavailable;
                    $assarray['timeavailable-kev']      = date('c', $content->timeavailable);
                    $assarray['timedue']                = $content->timedue;
                    $assarray['timedue-kev']            = date('c', $content->timedue);
                    $assarray['course']                 = $content->course;

                    $sql = "SELECT cm.id AS id
                        FROM ".$CFG->prefix."assignment AS a, ".$CFG->prefix."course_modules AS cm, ".$CFG->prefix."modules AS m
                        WHERE a.course = ".$content->course."
                        AND a.course = cm.course
                        AND cm.module = m.id
                        AND m.name = 'assignment'
                        AND cm.instance = a.id
                        AND a.id = ".$content->id.";";
                    $instance_res = $DB->get_record_sql($sql);
                    $assarray['instance'] = $instance_res->id;

                    $result[] = $assarray;
                }
            }

            return $result;
        }
    }

    /**
     * Returns description of method result value
     * @return external_description
     */
    public static function get_assignments_by_username_returns() {
        return new external_multiple_structure(
            new external_single_structure(
                array(
                    'id'                => new external_value(PARAM_INTEGER, 'ID of the assignment'),
                    'name'              => new external_value(PARAM_TEXT, 'Assignment name'),
                    'intro'             => new external_value(PARAM_TEXT, 'Assignment introduction, may contain HTML'),
                    'timeavailable'     => new external_value(PARAM_INTEGER, 'Date available from (set date)'),
                    'timeavailable-kev' => new external_value(PARAM_RAW, 'Date available from (set date) in Kev format'),
                    'timedue'           => new external_value(PARAM_INTEGER, 'Date available to (due date)'),
                    'timedue-kev'       => new external_value(PARAM_RAW, 'Date available to (due date) in Kev format'),
                    'course'            => new external_value(PARAM_INTEGER, 'ID of the course the assignment is set against'),
                    'instance'          => new external_value(PARAM_INTEGER, 'Module instance'),
                )
            )
        );
    }

}
