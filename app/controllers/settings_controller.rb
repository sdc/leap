class SettingsController < ApplicationController

  before_filter :admin_only

  def index
    @settings = Settings.defaults.keys.sort
  end

  def create
    Settings.defaults.keys.each do |k|
      if params[k] 
        Settings[k] = params[k]
      end
    end
    redirect_to settings_url
  end

end
