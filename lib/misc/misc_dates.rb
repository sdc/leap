module MISC
   class MiscDates

	  def acyr(checkdate = Date.today)
	    (d,m) = Settings.year_boundary_date.split("/").map{|x| x.to_i}
	    ab = checkdate.change(:day => d,:month => m)
	    if ab <= checkdate
	      return checkdate.strftime('%y')+'/'+(checkdate + 1.year).strftime('%y')
	    else
	      return (checkdate - 1.year).strftime('%y')+'/'+checkdate.strftime('%y')
	    end
	  end

	  def start_of_acyr(checkdate = Date.today)
	    (d,m) = Settings.year_boundary_date.split("/").map{|x| x.to_i}
	    ab = checkdate.change(:day => d,:month => m)
	    if ab <= checkdate
	      return ab
	    else
	      return (ab - 1.year)
	    end
	  end

	  def years_from_start_of_acyr(checkdate = Date.today)
	    (start_of_acyr() - start_of_acyr(checkdate)).to_i/365
	  end

   end
end