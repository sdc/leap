module MISC
   class MiscDates

	  def self.acyr(checkdate = Date.today)
	  	return nil if checkdate.nil?
	    (d,m) = Settings.year_boundary_date.split("/").map{|x| x.to_i}
	    ab = checkdate.change(:day => d,:month => m)
	    if ab <= checkdate
	      return checkdate.strftime('%y')+'/'+(checkdate + 1.year).strftime('%y')
	    else
	      return (checkdate - 1.year).strftime('%y')+'/'+checkdate.strftime('%y')
	    end
	  end

	  def self.start_of_acyr(checkdate = Date.today)
	    (d,m) = Settings.year_boundary_date.split("/").map{|x| x.to_i}
	    ab = checkdate.change(:day => d,:month => m)
	    if ab <= checkdate
	      return ab
	    else
	      return (ab - 1.year)
	    end
	  end

	  def self.startdate_from_acyr(acyr)
	  	return nil if acyr.nil? || acyr.length < 5
	  	checkdate = DateTime.strptime("01-01-20#{acyr[0,2]}", '%d-%m-%Y')
	    (d,m) = Settings.year_boundary_date.split("/").map{|x| x.to_i}
	    ab = checkdate.change(:day => d,:month => m)
        return ab.to_date
	  end

	  def self.enddate_from_acyr(acyr)
	  	return nil if acyr.nil? || acyr.length < 5
	  	checkdate = DateTime.strptime("01-01-20#{acyr[3,2]}", '%d-%m-%Y')
	    (d,m) = Settings.year_boundary_date.split("/").map{|x| x.to_i}
	    ab = checkdate.change(:day => d,:month => m)
	    ab = ab - 1.day
        return ab.to_date
	  end

	  def self.years_from_start_of_acyr(checkdate = Date.today)
	    (start_of_acyr() - start_of_acyr(checkdate)).to_i/365
	  end

	  def self.date_in_acyr(checkdate = Date.today, acyrs)
	  	return nil if checkdate.nil? || acyrs.nil?
	  	acyrs.flatten.join(",").split(",").include?( acyr(checkdate) ) unless acyrs.nil?
	  end

	  def self.is_date(datestr, picstr)
	  	return nil if datestr.nil? || picstr.nil?
		Date.strptime(datestr, picstr).present? rescue false
	  end

	  def self.make_date(datestr, picstr)
	  	return nil if datestr.nil? || picstr.nil?
		Date.strptime(datestr, picstr) rescue nil
	  end

   end
end