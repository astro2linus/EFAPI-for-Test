module EFMobile
	class API < Grape::API
    prefix 'api'
    helpers ApplicationHelper

    version 'v1', using: :header, vendor: 'EF Mobile'
    format :json

		desc "Returns the current API version, v1."
    get 'version' do
      { version: 'v1' }
    end

    desc 'Reset current unit'
    get 'users/:username/resetCurrentUnit' do  
      reset_current_unit
    end

    desc 'Reset current level'
    get 'users/:username/resetCurrentLevel' do
      reset_current_level
    end

    desc 'Load current unit progress'
    get 'users/:username/currentUnit' do 
      current_unit
    end

    desc 'Get user information'
    get "users/:username" do
      user_info
    end
	end
end