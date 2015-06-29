full_uri_from_request=Field.new("http.request.full_uri")

host_from_request=Field.new("http.request.uri")
http_query_params_proto=Proto("http.query_parameters","QueHambre")

function string.fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end


function http_query_params_proto.dissector(buffer,pinfo,tree)
	
	local full_uri_value=full_uri_from_request()
	if full_uri_value then
		local valor=tostring(full_uri_value)
		local host=host_from_request().value
		if string.match(host,"/analytics") then
			local iperf_mamount_range = buffer(91,35)
 			local iperf_mamount = iperf_mamount_range:bytes()
			
			local subtree=tree:add(http_query_params_proto,"QueHambre URI ubicacion")
			
			subtree:add("URI",iperf_mamount_F, iperf_mamount_range, tostring(iperf_mamount):fromhex())
		end
	end
end
register_postdissector(http_query_params_proto)

