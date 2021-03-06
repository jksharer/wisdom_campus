module SmsHelper
	require "net/http"
	require 'savon'

	# 发送违反秩序信息的短信，以违反秩序行为对象作为参数
	def send_message(message)
		params = cmcc_params(message)
    message.update_attribute(:send_time, params[:mttime])
    
    # HTTP
    # uri = URI("http://172.16.0.6:8090/httpmt")
    # response = Net::HTTP.post_form(uri, params)

    # SOAP
    client = Savon.client(wsdl: 'http://172.16.0.6:8090/services/esmsservice?wsdl')
    client.operations
    response = client.call(:sendSmsAsNormal, 
    												message: { phone: params[:phone],
    																	 msgcont: params[:msgcontent], 
    																	 spnumber: params[:cpoid], 
    																	 mttime: params[:mttime], 
    																	 cpid: params[:username],      
    																	 cppwd: params[:pwd] })
		response
	end

	# 根据行为信息生成短信对象
	def generate_message(behavior)
		sm = Sm.new
    sm.phone = behavior.student.phone
    sm.content = generate_content(behavior)
    sm.behavior = behavior
    sm.agency = my_agency
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
			"mttime"        => Time.now.strftime("%Y%m%d%H%M%S"),
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