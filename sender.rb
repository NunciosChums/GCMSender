require 'sinatra'
require 'gcm'

# for production mode
# set :port, 3002
set :environment, :production

get '/' do
	erb :index, :locals => {apiKey: '', regId: '', msg: ''}
end

put '/' do
	apiKey = params[:apiKey] || ''
	regIdStr = params[:regId] || ''
	msg = params[:msg] || ''

	if (!apiKey.empty? && !regIdStr.empty? && !msg.empty?)
	begin
		begin
			gcm = GCM.new(apiKey)
			regIDs= regIdStr.split(',')
			options = {data: JSON.parse(msg)}
			response = gcm.send_notification(regIDs, options)
			result = JSON.pretty_generate(response)
		rescue => error
			result = error
		end
	end
	else
		result = "error : fill all fields"
	end

	erb :index, :locals => {apiKey: apiKey, regId: regIdStr, msg: msg, response: result.to_s.force_encoding("UTF-8") }
end
