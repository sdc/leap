class Course < ActiveRecord::Base

  #has_many :events

  #def name(options = {})
  #  names = [forename]
  #  names += middle_names if options[:middle_names]
  #  if options[:surname_first]
  #    names.unshift "#{surname},"
  #  else
  #    names.push surname
  #  end
  #  names.join " "
  #end

  def Course.get(mis_id,fresh=false)
    (fresh ? false : find_by_mis_id(mis_id)) or MisConnector.get_course(mis_id)
  end

end
