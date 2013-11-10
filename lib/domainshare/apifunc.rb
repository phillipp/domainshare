module Domainshare
    class APIFUNC
        def initialize( name , args = [], opt_args = [])
            @url = "https://api.domainshare.tk" + "/" + name
            @args = args
            @opt_args = opt_args
        end
        
        def args
            @args
        end
        
        def opt_args
            @opt_args
        end
        
        def has_arg(value)
            @args.include(value) 
        end

        def encode_kvpair(req, k, vs)
          Array(vs).map {|v| "#{URI::encode(k.to_s)}=#{URI::encode(v.to_s)}" }
        end

        def set_form_data(req, params, sep = '&')
              req.body = params.map {|k, v| encode_kvpair(req, k, v) }.flatten.join(sep)
        req.content_type = 'application/x-www-form-urlencoded'
        end
      
        def call( params = {}, type = "xml" )
            url = URI.parse([ @url, type ].join("."))
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
#           Un-comment the following line to debug the api calls and responses.
#           http.set_debug_output $stderr
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?
            req = Net::HTTP::Post.new(url.path)
            self.set_form_data( req, params, ';')
            resp = http.start {|http| http.request(req) }
            resp.body
        end
    end
end