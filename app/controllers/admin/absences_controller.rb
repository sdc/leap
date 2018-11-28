class Admin::AbsencesController < ApplicationController

	before_action :admin_page

	def index
		@date = Date.today
		@absences = Absence.all
	end

	def change_date
		@date = params[:absence_date].to_date
		@absences = Absence.all
		render "index"
	end

end