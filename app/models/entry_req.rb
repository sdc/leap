require "csv"

class EntryReq < ActiveRecord::Base
  attr_accessible :body, :category

  belongs_to :course

  def self.import(file)
    old_logger_level, logger.level = logger.level, Logger::ERROR if logger
    CSV.foreach(file) do |row|
      if course=Course.find_by_year_and_code("14/15",row[0])
        ["Numeracy","Literacy","General","Specialist","Additional"].each_with_index do |r,i|
          next if row[i+1].blank?
          next if course.entry_reqs.where(:category => r).first
          course.entry_reqs.create(:category => r,:body => row[i+1]) unless row[i+1] == "Please select"
	  puts "Added #{r} to #{course.name}"
        end
      else 
        puts "*" * 40
        puts row[0] + " - not found!"
      end
    end
  ensure
    logger.level = old_logger_level if logger
  end
end
