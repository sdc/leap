begin
  Settings.save_default(:ebs_course_base_url, "http://ebs4agent-live.southdevon.internal/#/DynamicPage?page=CourseDetails&dp2=uio_id%2cDecimal%2c")
  Settings.save_default(:ebs_person_base_url, "http://ebs4agent-live.southdevon.internal/#/DynamicPage?page=LearnerDetails&dp2=PersonCode%2cDecimal%2c")
  Settings.save_default(:front_page_note_prompt, "What do I need to do today?")
  Settings.save_default(:notify_details_change_url, "https://spreadsheets.google.com/a/southdevon.ac.uk/viewform?formkey=dEtUWldxeTJMMXhLWTI5d3ZIRmtSUnc6MQ")
  Settings.save_default(:target_default_length, 2.weeks)
  Settings.save_default(:support_request_difficulties, "Reading,Comprehension,Spelling,Writing,Proof-reading,Planning work,Organising work,Concentration,Study Skills,Numeracy")
  Settings.save_default(:support_history_categories, "Identified specific learning difficulty,Difficulties with literacy,Difficulties with numeracy,Difficulties with english as a foreign language,Visual and/or hearing impairment,Physical disability,Medical condition/mental health,Support at school,Support at college,Statement at school,Extra time in exams,Reader in exams,Scribe in exams")
  Settings.save_default(:admin_users, [1])
  Settings.save_default(:google_analytics_code, "")
  Settings.save_default(:advert_box_html, "<p>Blank Space!</p>")
  Settings.save_default(:maintenance_mode, "")
  Settings.save_default(:students_create_events, "targets,notes,profile_questions,qualifications")
  Settings.save_default(:students_update_events, "targets,support_strategies")
  Settings.save_default(:year_boundary_date, "01/09")
  Settings.save_default(:sdc, "")
  Settings.save_default(:test_logins, [])
  Settings.save_default(:delete_delay, 1.hour)
  Settings.save_default(:review_windows, "test_review")
  Settings.save_default(:current_review_window, "test_review")
  Settings.save_default(:progression_reviews_reasons, "Not working at required level,Non-attendance,Changed mind about Career Aim/going onto a different course,Non-submission of work,Not achieving targets,Inappropriate behaviour")
  Settings.save_default(:disciplinary_levels, "-1,Amber Alert Disciplinary,0,Amber Alert Pastoral,1,Positive Intervention Stage One,2,Positive Intervention Stage Two,3,Positive Intervention Stage Three")
  Settings.save_default(:intervention_types, "Pre-enrolment:Personal Issues,Social Isolation/Shyness,Cheese Fetish;Pastoral:Sheep,Cows,Eggs,Ducks")
  Settings.save_default(:hide_staff_personal_details, 0)
  Settings.save_default(:ebs_import_options, "save,courses,quals")
  Settings.save_default(:review_grades, "0,1,2,3,4,5,6,7,8,9,10")
  Settings.save_default(:profile_questions, "My favourite subject at school and why;My work experience;My long term ambitions;My hobbies and interests;My course feedback;My Night feedback;Welcome Day feedback")
  Settings.save_default(:application_offer_text, "You have a guaranteed offer of a place on a course at college (in accordance with the college's admissions policy). To guarantee your place on your course of choice you will need to meet the entry requirements as per the prospectus.")
  Settings.save_default(:application_title_field, "")
  Settings.save_default(:current_simple_poll, "")

  # BKSB Import Settings
  Settings.save_default(:bksb_url, "")
  Settings.save_default(:bksb_pwd, "")
  Settings.save_default(:bksb_iis_username, "")
  Settings.save_default(:bksb_iis_pwd, "")

  # Quals 
  Settings.save_default(:qqoe_qual_type, "A,B,C")
  Settings.save_default(:qqoe_awarding_body, "D,E,F")
  Settings.save_default(:qqoe_subject, "Dormouse,G,H,I")
  Settings.save_default(:qqoe_grade, "A*,A,B,C,D,E,F,G,Pass")
  Settings.save_default(:qqoe_select_type, "Select")
  Settings.save_default(:quals_editing, "off")

  # Pathways setup
  Settings.save_default(:pathways, "English:Entry Level 3 Functional Skills,Level 1 Functional Skills,Level 2 Functional Skills,GCSE,Stretch & Challenge;Maths:Entry Level 3 Functional Skills,Level 1 Functional Skills,Level 2 Functional Skills,GCSE,Stretch & Challenge")

  # Silly Pictures 
  Settings.save_default(:lorem_pictures, "")

  # Review score categories
  Settings.save_default(:review_cat_quality, "Quality of Work")
  Settings.save_default(:review_cat_punctuality, "Punctuality")
  Settings.save_default(:review_cat_attitude, "Attitude")
  Settings.save_default(:review_cat_completion, "Completion of Work")
  Settings.save_default(:reverse_scores, "Forward")

  # One-to-one review questions and prompts
  Settings.save_default(:one_to_one_prompts, "")

  # Event Notes
  Settings.save_default(:event_notes, "staff")

  # TtActivity categories
  Settings.save_default(:tt_activity_categories, "One,Two,Three")

  # Moodle Integration
  Settings.save_default(:moodle_host, "")
  Settings.save_default(:moodle_path, "")
  Settings.save_default(:moodle_token, "")
  Settings.save_default(:moodle_user_postfix, "")
  Settings.save_default(:moodle_link_target, "_self")
  Settings.save_default(:moodle_badge_block_courses, "")
  Settings.save_default(:moodle_grade_track_import, "off")
  Settings.save_default(:moodle_badge_import, "off")

  # Attendance Import
  Settings.save_default(:attendance_table, "")
  Settings.save_default(:attendance_culm_column, "")
  Settings.save_default(:attendance_week_column, "")
  Settings.save_default(:attendance_type_column, "")
  Settings.save_default(:attendance_date_column, "")
  Settings.save_default(:attendance_low_score, 85)
  Settings.save_default(:attendance_high_score, 90)

  # Stylesheets
  # This is pretty hacky but just dumps some arbitrary css into a style tag in the layout
  Settings.save_default(:custom_css, "")

  # Links
  # The links on the clidebar
  Settings.save_default(:clidebar_links, "")
  Settings.save_default(:ebs_link_name, "EBS")
  Settings.save_default(:ebs_link_icon, "fa-bolt")

  # Which home page
  Settings.save_default(:home_page, "old")

  Settings.save_default(:ebs_no_contact, nil)

  #Web services
  Settings.save_default(:ws_user, "")
  Settings.save_default(:ws_token, "")

  Settings.save_default(:ebs_username_field, "network_userid")
rescue 
  puts "Settings can't be loaded. If you're just setting things up for the first time this is OK. If not... um... start crying."
end
