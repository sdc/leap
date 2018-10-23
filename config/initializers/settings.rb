# Settings.defaults[:ebs_course_base_url]          = "http://ebs4agent-live.southdevon.internal/#/DynamicPage?page=CourseDetails&dp2=uio_id%2cDecimal%2c"
# Settings.defaults[:ebs_person_base_url]          = "http://ebs4agent-live.southdevon.internal/#/DynamicPage?page=LearnerDetails&dp2=PersonCode%2cDecimal%2c"
Settings.defaults[:ebs_person_base_url]          = "http://ebsontrackplus-live.southdevon.internal/Page/LearnerDetails?PersonCode="
Settings.defaults[:ebs_course_base_url]          = "http://ebsontrackplus-live.southdevon.internal/Page/CourseDetails?uio_id="
Settings.defaults[:front_page_note_prompt]       = "What do I need to do today?"
Settings.defaults[:notify_details_change_url]    = "https://spreadsheets.google.com/a/southdevon.ac.uk/viewform?formkey=dEtUWldxeTJMMXhLWTI5d3ZIRmtSUnc6MQ"
Settings.defaults[:target_default_length]        = 2.weeks
Settings.defaults[:support_request_difficulties] = "Reading,Comprehension,Spelling,Writing,Proof-reading,Planning work,
                                                    Organising work,Concentration,Study Skills,Numeracy"
Settings.defaults[:support_history_categories]   = "Identified specific learning difficulty,Difficulties with literacy,Difficulties with numeracy,Difficulties with english as a foreign language,Visual and/or hearing impairment,Physical disability,Medical condition/mental health,Support at school,Support at college,Statement at school,Extra time in exams,Reader in exams,Scribe in exams"
Settings.defaults[:admin_users]                  = [1]
Settings.defaults[:google_analytics_code]        = ""
Settings.defaults[:advert_box_html]              = "<p>Blank Space!</p>"
Settings.defaults[:maintenance_mode]             = ""
Settings.defaults[:students_create_events]       = "targets,notes,profile_questions,qualifications"
Settings.defaults[:students_update_events]       = "targets,support_strategies"
Settings.defaults[:year_boundary_date]           = "01/09"
Settings.defaults[:sdc]                          = ""
Settings.defaults[:test_logins]                  = []
Settings.defaults[:delete_delay]                 = 1.hour
Settings.defaults[:review_windows]               = "test_review"
Settings.defaults[:current_review_window]        = "test_review"
Settings.defaults[:progression_reviews_reasons]  = "Not working at required level,Non-attendance,Changed mind about Career Aim/going onto a different course,Non-submission of work,Not achieving targets,Inappropriate behaviour"
Settings.defaults[:disciplinary_levels]          = "-1,Amber Alert Disciplinary,0,Amber Alert Pastoral,1,Positive Intervention Stage One,2,Positive Intervention Stage Two,3,Positive Intervention Stage Three"
Settings.defaults[:intervention_types]           = "Pre-enrolment:Personal Issues,Social Isolation/Shyness,Cheese Fetish;Pastoral:Sheep,Cows,Eggs,Ducks"
Settings.defaults[:hide_staff_personal_details]  = 0
Settings.defaults[:ebs_import_options]           = "save,courses,quals"
Settings.defaults[:review_grades]                = "0,1,2,3,4,5,6,7,8,9,10"
Settings.defaults[:induction_questions]          = "Study Programme including progression plan and English and Maths;Attendance;Behaviour;British Values;Progress and attendance reviews including Target Grades;Study Skills;Work Related Opportunities;Safeguarding;Prevent"
Settings.defaults[:induction_question_badges]    = ""
Settings.defaults[:profile_questions]            = "My favourite subject at school and why;My work experience;My long term ambitions;My hobbies and interests;My course feedback;My Night feedback;Welcome Day feedback"
Settings.defaults[:application_offer_text] 	= "You have a guaranteed offer of a place on a course at college (in accordance with the college's admissions policy). To guarantee your place on your course of choice you will need to meet the entry requirements as per the prospectus."
Settings.defaults[:application_title_field] = ""
Settings.defaults[:current_simple_poll] = ""
Settings.defaults[:notified_events] = "ContactLog;Intervention;SupportPlan;ProgressReview;InitialReview"
Settings.defaults[:work_package_types] = ""
Settings.defaults[:news_modal] = "off"
Settings.defaults[:intervention_groups]           = "PII:Positive Intervention Pastoral:Pastoral;Advice & Guidance;Alleged Bullying|PIB:Positive Intervention Behaviour:Amber Alert Disciplinary;Amber Alert Behaviour;Stage 1 Behaviour Disc;Stage 2 Behaviour Disc;Stage 3 Behaviour Disc|PIA:Positive Intervention Attendance:Amber Alert Attendance;Stage 1 Attendance Disc;Stage 2 Attendance Disc;Stage 3 Attendance Disc|PIP:Positive Intervention Progress:Stage 1 Progress Intervention;Stage 2 Progress Intervention;Stage 3 Progress Intervention"

# BKSB Import Settings
Settings.defaults[:bksb_url] = ""
Settings.defaults[:bksb_pwd] = ""
Settings.defaults[:bksb_iis_username] = ""
Settings.defaults[:bksb_iis_pwd] = ""

# Quals 
Settings.defaults[:qqoe_qual_type] = "A,B,C"
Settings.defaults[:qqoe_awarding_body] = "D,E,F"
Settings.defaults[:qqoe_subject] = "Dormouse,G,H,I"
Settings.defaults[:qqoe_grade] = "A*,A,B,C,D,E,F,G,Pass"
Settings.defaults[:qqoe_select_type] = "Select"
Settings.defaults[:quals_editing] = "off"

# Pathways setup
Settings.defaults[:pathways] = "English:Entry Level 3 Functional Skills,Level 1 Functional Skills,Level 2 Functional Skills,GCSE,Stretch & Challenge;Maths:Entry Level 3 Functional Skills,Level 1 Functional Skills,Level 2 Functional Skills,GCSE,Stretch & Challenge"

# Silly Pictures 
Settings.defaults[:lorem_pictures] = ""

# Review score categories
Settings.defaults[:review_cat_quality] = "Quality of Work"
Settings.defaults[:review_cat_punctuality] = "Punctuality"
Settings.defaults[:review_cat_attitude] = "Attitude"
Settings.defaults[:review_cat_completion] = "Completion of Work"
Settings.defaults[:reverse_scores] = "Forward"

# One-to-one review questions and prompts
Settings.defaults[:one_to_one_prompts] = ""

# Event Notes
Settings.defaults[:event_notes] = "staff"

# TtActivity categories
Settings.defaults[:tt_activity_categories] = "One,Two,Three"

# Moodle Integration
Settings.defaults[:moodle_host]                  = ""
Settings.defaults[:moodle_path]                  = ""
Settings.defaults[:moodle_token]                 = ""
Settings.defaults[:moodle_user_postfix]          = ""
Settings.defaults[:moodle_link_target]           = "_self"
Settings.defaults[:moodle_badge_block_courses]   = ""
Settings.defaults[:moodle_grade_track_import]    = "off"
Settings.defaults[:moodle_badge_import]          = "off"
Settings.defaults[:moodle_badge_plp_courses]     = ""

# Attendance Import
Settings.defaults[:attendance_table]             = ""
Settings.defaults[:attendance_culm_column]       = ""
Settings.defaults[:attendance_week_column]       = ""
Settings.defaults[:attendance_type_column]       = ""
Settings.defaults[:attendance_date_column]       = ""
Settings.defaults[:attendance_low_score]         = 85
Settings.defaults[:attendance_high_score]        = 90
Settings.defaults[:attendance_exceed_score]      = 98

# Stylesheets
# This is pretty hacky but just dumps some arbitrary css into a style tag in the layout
Settings.defaults[:custom_css] = ""

# Links
# The links on the clidebar
Settings.defaults[:clidebar_links] = ""
Settings.defaults[:ebs_link_name] = "EBS"
Settings.defaults[:ebs_link_icon] = "fa-bolt"

# Which home page
Settings.defaults[:home_page] = "old"
Settings.defaults[:home_page_staff] = "old"
Settings.defaults[:home_page_student] = "old"
Settings.defaults[:home_page_applicant] = "old"
Settings.defaults[:home_page_affiliate] = "old"

Settings.defaults[:ebs_no_contact] = nil

#Web services
Settings.defaults[:ws_user] = ""
Settings.defaults[:ws_token] = ""

Settings.defaults[:ebs_username_field] = "network_userid"

#PLP Tabs
Settings.defaults[:plp_overview] 						= "old"
Settings.defaults[:plp_tabs] 							= "photos,overview,reviews,support,checklist,badges,achievement"
Settings.defaults[:plp_pi_groups] 						= "PIA,PIB,PII,PIP"
Settings.defaults[:plp_pi_groups_breakdown] 			= "off"
Settings.defaults[:plp_attendance_bm_date_ranges]      	= "I;03/09/2018;01/10/2018;18/19|1;03/09/2018;19/10/2018;18/19|2;29/10/2018;21/12/2018;18/19|3;08/01/2019;15/02/2019;18/19|4;25/02/2019;05/04/2019;18/19|5;23/04/2019;24/05/2019;18/19"
Settings.defaults[:plp_progress_bm_date_ranges]      	= "I;01/10/2018;12/10/2018;18/19|1;13/10/2018;16/11/2018;18/19|2;17/11/2018;25/01/2019;18/19|3;26/01/2019;15/03/2019;18/19|4;16/03/2019;10/05/2019;18/19|5;11/05/2019;21/06/2019;18/19"

#Progress Reviews settings
Settings.defaults[:num_progress_reviews] 		= 5
Settings.defaults[:par_active]           		= "I,1,2,3,4,5"
Settings.defaults[:par_restrict_active]  		= "off"
Settings.defaults[:par_date_ranges]      		= "I;02/10/2017;13/10/2017;17/18|1;30/10/2017;17/11/2017;17/18|2;30/11/2017;26/01/2018;17/18|3;19/02/2018;09/03/2018;17/18|4;16/04/2018;04/05/2018;17/18|5;04/06/2018;29/06/2018;17/18|I;01/10/2018;12/10/2018;18/19|1;29/10/2018;23/11/2018;18/19|2;07/01/2019;25/01/2019;18/19|3;25/02/2019;15/03/2019;18/19|4;22/04/2019;10/05/2019;18/19|5;10/06/2019;28/06/2019;18/19"
Settings.defaults[:par_restrict_date_ranges] 	= "I,1,2,3,4,5"
Settings.defaults[:par_edit_window]      		= 1.day
Settings.defaults[:par_window_type]      		= ""
Settings.defaults[:par_guidance]         		= "1,2,4,5#Guidance:||Overall Learner/Tutor Comments|Review improvement targets from previous PAR – have these been met? How has this been evidenced?#par-guidance-previous|Improvement targets for next PAR (including any carried over from previous PAR)#par-guidance-next|||3#Guidance:||Overall Learner/Tutor Comments|Review improvement targets from previous PAR – have these been met? How has this been evidenced?#par-guidance-previous|Improvement targets for next PAR (including any carried over from previous PAR). Please focus on skills and knowledge for improvement targets#par-guidance-next"
Settings.defaults[:par_guidance_active]  		= "off"

# e-laaf settings
Settings.defaults[:elaaf_link_enabled]          		= 1
Settings.defaults[:elaaf_link_icon]          			= "fa-random"
Settings.defaults[:elaaf_link_name]          			= "e-LAAF"
Settings.defaults[:elaaf_base_url]          			= "http://elaaf.shapps.southdevon.ac.uk/elaaf/pages/default.aspx?SN=@sn"
Settings.defaults[:elaaf_student_number_place_holder]   = "@sn"

# Continuing Learning categories
Settings.defaults[:continuing_learning_rev_enabled]  	= 1
Settings.defaults[:continuing_learning_colours] 		= "red;red|amber;amber|green;green|purple;purple"
Settings.defaults[:continuing_learning_icons] 			= "Higher Education Elsewhere;fa-sign-out|College Further Education/Apprenticeship;fa-book|Looking for Work/Apprenticeship/Self Employed;fa-binoculars|College Higher Education;fa-graduation-cap|Want to stay at college not applied;fa-anchor|Not Sure;fa-arrows-h"
Settings.defaults[:continuing_learning_default_colour]	= "grey"
Settings.defaults[:continuing_learning_default_icon]	= "fa-question"

# Network Miscellaneous
Settings.defaults[:network_ip_ranges] = "1;192.168.0.1;192.168.255.254;Private network Class C|1;172.16.0.1;172.31.255.254;Private network Class B|1;10.0.0.1;10.255.255.254;Private network Class A|1;127.0.0.1;127.255.255.254;localhost"

# Registers Threshold
Settings.defaults[:timetable_registers_threshold]       = "01/08"

Settings.defaults[:absence_line_email] = "helpzone@southdevon.ac.uk"

# Superuser Settings - applicable only to Superusers
Settings.defaults[:su_send_emails]  = "off"
