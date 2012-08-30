CREATE TABLE "absences" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "created_by_id" integer, "lessons_missed" integer, "category" varchar(255), "body" text, "usage_code" varchar(255), "contact_category" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "attendances" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "week_beginning" date, "person_id" integer, "att_year" integer, "att_3_week" integer, "att_week" integer, "created_by_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "contact_logs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "body" text, "created_by_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "courses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "code" varchar(255), "year" varchar(255), "mis_id" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "disciplinaries" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "body" text, "level" integer, "created_by_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "events" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "eventable_type" varchar(255) NOT NULL, "eventable_id" integer NOT NULL, "event_date" datetime NOT NULL, "about_person_id" integer, "parent_id" integer, "transition" varchar(255), "created_by_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "goals" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "body" text, "status" varchar(255), "created_by_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "interventions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "referral_text" text, "disc_text" text, "created_by_id" integer, "pi_type" varchar(255), "referral_category" varchar(255), "incident_date" date, "referral" boolean, "workshops" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "notes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "body" text, "created_by_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "people" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "forename" varchar(255), "surname" varchar(255), "middle_names" varchar(255), "address" varchar(255), "town" varchar(255), "postcode" varchar(255), "mobile_number" varchar(255), "next_of_kin" varchar(255), "date_of_birth" date, "uln" integer, "mis_id" varchar(255), "username" varchar(255), "created_at" datetime, "updated_at" datetime, "tutor_id" integer, "my_courses" varchar(255), "staff" boolean);
CREATE TABLE "person_courses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "course_id" integer, "application_date" datetime, "enrolment_date" datetime, "end_date" datetime, "start_date" datetime, "status" varchar(255), "created_by_id" integer, "created_at" datetime, "updated_at" datetime, "mis_status" varchar(255));
CREATE TABLE "progression_reviews" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "created_by_id" integer, "approved" boolean, "reason" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "qualifications" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "title" varchar(255), "grade" varchar(255), "mis_id" integer, "created_by_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "review_lines" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "body" text, "created_by_id" integer, "quality" integer, "attitude" integer, "punctuality" integer, "completion" integer, "created_at" datetime, "updated_at" datetime, "window" varchar(255), "unit" varchar(255), "review_id" integer);
CREATE TABLE "reviews" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "created_by_id" integer, "window" varchar(255), "attendance" integer, "score" integer, "created_at" datetime, "updated_at" datetime, "body" text, "published" boolean);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "settings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "var" varchar(255) NOT NULL, "value" text, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "support_histories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "created_by_id" integer, "body" varchar(255), "category" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "support_requests" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "created_by_id" integer, "difficulties" varchar(255), "sessions" varchar(255), "created_at" datetime, "updated_at" datetime, "workshop" boolean);
CREATE TABLE "support_strategies" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "created_by_id" integer, "event_id" integer, "body" text, "agreed_date" datetime, "completed_date" datetime, "declined_date" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "targets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "event_id" integer, "body" text, "actions" text, "reflection" text, "target_date" datetime, "complete_date" datetime, "drop_date" datetime, "created_by_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "views" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "transitions" varchar(255), "events" varchar(255), "icon_url" varchar(255), "affiliations" varchar(255), "name" varchar(255), "label" varchar(255), "controls" varchar(255), "position" integer, "in_list" boolean, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_absences_on_person_id" ON "absences" ("person_id");
CREATE INDEX "index_attendances_on_person_id" ON "attendances" ("person_id");
CREATE INDEX "index_attendances_on_week_beginning" ON "attendances" ("week_beginning");
CREATE INDEX "index_contact_logs_on_created_by_id" ON "contact_logs" ("created_by_id");
CREATE INDEX "index_contact_logs_on_person_id" ON "contact_logs" ("person_id");
CREATE INDEX "index_courses_on_code" ON "courses" ("code");
CREATE INDEX "index_courses_on_title" ON "courses" ("title");
CREATE INDEX "index_disciplinaries_on_person_id" ON "disciplinaries" ("person_id");
CREATE INDEX "index_events_on_event_date" ON "events" ("event_date");
CREATE INDEX "index_events_on_eventable_id" ON "events" ("eventable_id");
CREATE INDEX "index_events_on_eventable_type" ON "events" ("eventable_type");
CREATE INDEX "index_events_on_parent_id" ON "events" ("parent_id");
CREATE INDEX "index_events_on_person_id" ON "events" ("person_id");
CREATE INDEX "index_events_on_transition" ON "events" ("transition");
CREATE INDEX "index_goals_on_person_id" ON "goals" ("person_id");
CREATE INDEX "index_initial_reviews_on_person_id" ON "review_lines" ("person_id");
CREATE INDEX "index_notes_on_person_id" ON "notes" ("person_id");
CREATE INDEX "index_people_on_forename" ON "people" ("forename");
CREATE INDEX "index_people_on_mis_id" ON "people" ("mis_id");
CREATE INDEX "index_people_on_surname" ON "people" ("surname");
CREATE INDEX "index_people_on_username" ON "people" ("username");
CREATE INDEX "index_person_courses_on_course_id" ON "person_courses" ("course_id");
CREATE INDEX "index_person_courses_on_person_id" ON "person_courses" ("person_id");
CREATE INDEX "index_progression_reviews_on_person_id" ON "progression_reviews" ("person_id");
CREATE INDEX "index_qualifications_on_person_id" ON "qualifications" ("person_id");
CREATE INDEX "index_review_lines_on_review_id" ON "review_lines" ("review_id");
CREATE INDEX "index_reviews_on_person_id" ON "reviews" ("person_id");
CREATE INDEX "index_support_histories_on_person_id" ON "support_histories" ("person_id");
CREATE INDEX "index_support_requests_on_person_id" ON "support_requests" ("person_id");
CREATE INDEX "index_support_strategies_on_event_id" ON "support_strategies" ("event_id");
CREATE INDEX "index_support_strategies_on_person_id" ON "support_strategies" ("person_id");
CREATE INDEX "index_targets_on_event_id" ON "targets" ("event_id");
CREATE INDEX "index_targets_on_person_id" ON "targets" ("person_id");
CREATE INDEX "index_views_on_name" ON "views" ("name");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110105125535');

INSERT INTO schema_migrations (version) VALUES ('20110105125929');

INSERT INTO schema_migrations (version) VALUES ('20110106140244');

INSERT INTO schema_migrations (version) VALUES ('20110112014300');

INSERT INTO schema_migrations (version) VALUES ('20110127110340');

INSERT INTO schema_migrations (version) VALUES ('20110127141643');

INSERT INTO schema_migrations (version) VALUES ('20110202170356');

INSERT INTO schema_migrations (version) VALUES ('20110607142802');

INSERT INTO schema_migrations (version) VALUES ('20110616133220');

INSERT INTO schema_migrations (version) VALUES ('20110623133337');

INSERT INTO schema_migrations (version) VALUES ('20110627081652');

INSERT INTO schema_migrations (version) VALUES ('20110704201947');

INSERT INTO schema_migrations (version) VALUES ('20110720145602');

INSERT INTO schema_migrations (version) VALUES ('20110721142947');

INSERT INTO schema_migrations (version) VALUES ('20110815133038');

INSERT INTO schema_migrations (version) VALUES ('20110822110644');

INSERT INTO schema_migrations (version) VALUES ('20110907123204');

INSERT INTO schema_migrations (version) VALUES ('20110911145829');

INSERT INTO schema_migrations (version) VALUES ('20110912101633');

INSERT INTO schema_migrations (version) VALUES ('20111007091601');

INSERT INTO schema_migrations (version) VALUES ('20111011081143');

INSERT INTO schema_migrations (version) VALUES ('20111011085825');

INSERT INTO schema_migrations (version) VALUES ('20111024130132');

INSERT INTO schema_migrations (version) VALUES ('20111027090030');

INSERT INTO schema_migrations (version) VALUES ('20111103085034');

INSERT INTO schema_migrations (version) VALUES ('20120208110650');

INSERT INTO schema_migrations (version) VALUES ('20120628102848');

INSERT INTO schema_migrations (version) VALUES ('20120704094614');