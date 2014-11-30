module ApplicationHelper

  SERVICE = "http://mobiledev.englishtown.com/services/school/_tools/progress/SubmitScoreHelper.aspx"

  def host_url
    "http://#{request.host}:#{request.port}"
  end

	def username
		params[:username]
	end

	def user_options(args = {})
		{query: {cmd: 'loadStudentInfo', member_id: args[:username] || username }} 
	end

  def unit_options(args = {})
    user = user_info
    { query: 
        {
          'cmd' => 'loadUnitProgress',
          'member_id' => user[:member_id],
          'course_id' => user[:course_id],
          'unit_id' => user[:unit_id],
          'hasEvc' => user[:has_evc],
          'enrollToUnit' => 'false',
          'resetUnit' =>  'false'
        }.merge(args)
      }
  end

  def parse_user_info(text)
    splitted = text.split("|")
    {
      :username => splitted[1],
      :member_id => splitted[3],
      :course_id => splitted[7], # Currently enrolled course
      :unit_id => splitted[0], # Currently enrolled unit
      :has_evc => (splitted[2] == "1").to_s,
      :partner_code => splitted[4],
      :courses => splitted[5].split("#").map { |c| Hash[[:course_id,:course_title].zip(c.split("$"))] },
      :units => splitted[6].split("#").map { |c| Hash[[:unit_id,:unit_title].zip(c.split("$"))] }
    } 
  end

  def user_info
    @user_info ||= parse_user_info HTTParty.post(SERVICE, user_options)
  end

  def current_unit
    HTTParty.post(SERVICE, unit_options)
  end

  def reset_current_unit
    HTTParty.post(SERVICE, unit_options({'resetUnit' => 'true'}))
  end

  def reset_current_level
    begin
      user_info[:units].each do |unit|
        HTTParty.post(SERVICE, unit_options({'resetUnit' => 'true', 'unit_id' => unit[:unit_id]}))
      end
      {response: "OK"}
    rescue Exception => e
      {response: "Failed"}
    end
  end
end
