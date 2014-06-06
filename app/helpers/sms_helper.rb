module SmsHelper
	require "net/http"

	# 发送违反秩序信息的短信，以违反秩序行为对象作为参数
	def send_message(behavior)
		@sm = generate_message(behavior)       # 根据行为对象信息生成短信
		@sm.save                               # 在发起post请求前将短信存入数据库

		uri = URI("http://211.142.19.253:8080/httpmt")
		puts uri.request_uri
		puts cmcc_params(@sm)
		response = Net::HTTP.post_form(uri, cmcc_params(@sm))

		# request = Net::HTTP::Post.new(uri.request_uri)     
		# request.set_form_data(cmcc_params(@sm))
		# # 发起http post请求
		# response = Net::HTTP.start(uri.host, uri.port) do |http|
		# 	puts "#{uri}-#{request.body}"
		# 	http.request(request)
		# end

		puts response.code
		puts response.message
		puts response.value

		case response
			when Net::HTTPSuccess, Net::HTTPRedirection
				@sm.update_attribute(:status, "success")         # 如果发送成功，则更新短信信息的状态为success
			  return "success"
			else
				@sm.update_attribute(:status, "failue")
			  return response.message
			end
	end

	# 根据行为信息生成短信对象
	def generate_message(behavior)
		sm = Sm.new
    sm.behavior = behavior
    sm.agency = my_agency
    sm.mid = "#{my_agency.id}#{behavior.id}"
    sm.phone = "13834231586"
    sm.content = generate_content(behavior)
    sm.send_time = time_format_min(Time.now)
    sm.status = "new"
    return sm
	end

	# 根据中国移动SMS接口要求生成相应参数列表
	def cmcc_params(sm)
		{
			"username"      => "apiht_605",
			"pwd"           => "apiht#605",
			"attestation"   => Digest::MD5.hexdigest("apiht_605keyapiht#605"),
			"phone"         => sm.phone,
			"msgcontent"    => sm.content,
			"mttime"        => "20140605231800",
			"cpoid"         => sm.mid,
			"sendType"      => "1"
		}
	end

	# 根据行为对象生成短信内容
	def generate_content(behavior)
		"您好, 您家孩子#{behavior.student.name}(#{behavior.student.iclass.grade.name}#{behavior.student.iclass.name}), 
			于#{time_format_min(behavior.time)}, 在#{behavior.address}发生#{behavior.behavior_type.name}行为, 
			详细信息: #{behavior.description}. 请您知晓."
	end

end