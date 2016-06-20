Settings.defaults[:ebs_course_base_url]          = "http://ebs4agent-live.southdevon.internal/#/DynamicPage?page=CourseDetails&dp2=uio_id%2cDecimal%2c"
Settings.defaults[:ebs_person_base_url]          = "http://ebs4agent-live.southdevon.internal/#/DynamicPage?page=LearnerDetails&dp2=PersonCode%2cDecimal%2c"
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
Settings.defaults[:induction_checklist]          = "Study Programme including progression plan and English and Maths;Attendance;Behaviour;British Values;Progress and attendance reviews including Target Grades;Study Skills;Work Related Opportunities;Safeguarding;Prevent"
Settings.defaults[:profile_questions]            = "My favourite subject at school and why;My work experience;My long term ambitions;My hobbies and interests;My course feedback;My Night feedback;Welcome Day feedback"
Settings.defaults[:application_offer_text] = "You have a guaranteed offer of a place on a course at college (in accordance with the college's admissions policy). To guarantee your place on your course of choice you will need to meet the entry requirements as per the prospectus."
Settings.defaults[:application_title_field] = ""
Settings.defaults[:current_simple_poll] = ""

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

# Attendance Import
Settings.defaults[:attendance_table]             = ""
Settings.defaults[:attendance_culm_column]       = ""
Settings.defaults[:attendance_week_column]       = ""
Settings.defaults[:attendance_type_column]       = ""
Settings.defaults[:attendance_date_column]       = ""
Settings.defaults[:attendance_low_score]         = 85
Settings.defaults[:attendance_high_score]        = 90

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

Settings.defaults[:ebs_no_contact] = nil

#Web services
Settings.defaults[:ws_user] = ""
Settings.defaults[:ws_token] = ""

Settings.defaults[:ebs_username_field] = "network_userid"
