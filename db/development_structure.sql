CREATE TABLE "courses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "code" varchar(255), "year" varchar(255), "mis_id" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "events" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "eventable_type" varchar(255), "eventable_id" integer, "event_date" datetime, "parent_id" integer, "transition" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "goals" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "body" text, "status" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "notes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "body" text, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "people" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "forename" varchar(255), "surname" varchar(255), "middle_names" varchar(255), "address" varchar(255), "town" varchar(255), "postcode" varchar(255), "mobile_number" varchar(255), "next_of_kin" varchar(255), "date_of_birth" date, "uln" integer NOT NULL, "mis_id" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "person_courses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "course_id" integer, "application_date" datetime, "enrolment_date" datetime, "end_date" datetime, "status" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "targets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer, "event_id" integer, "body" text, "actions" text, "reflection" text, "target_date" datetime, "complete_date" datetime, "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110105125535');

INSERT INTO schema_migrations (version) VALUES ('20110105125929');

INSERT INTO schema_migrations (version) VALUES ('20110106140244');

INSERT INTO schema_migrations (version) VALUES ('20110112014300');

INSERT INTO schema_migrations (version) VALUES ('20110127110340');

INSERT INTO schema_migrations (version) VALUES ('20110127141643');

INSERT INTO schema_migrations (version) VALUES ('20110202170356');