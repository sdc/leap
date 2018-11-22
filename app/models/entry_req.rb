require "csv"

class EntryReq < ActiveRecord::Base
  
  belongs_to :course

  def self.import(file)
    old_logger_level, logger.level = logger.level, Logger::ERROR if logger
    CSV.foreach(file) do |row|
      app_title = row[0]
      course_title = row[1]
      course_qual = row[2]
      ["Maths","English","General","Specialist","Specialist 2"].each_with_index do |r,i|
        next if row[i+3].blank?
        er = EntryReq.find_or_create_by_app_title_and_course_title_and_course_qual_and_category_and_live(app_title,course_title,course_qual,r,true)
	      puts "Added #{r} to #{course.name}"
      end
    end
  ensure
    logger.level = old_logger_level if logger
  end
end
