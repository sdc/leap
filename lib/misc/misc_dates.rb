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