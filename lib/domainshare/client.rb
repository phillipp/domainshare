module Domainshare
    class Client
        @@WARN = false
        def initialize(email, password)
            if (email.empty? or password.empty?) and @@WARN
                puts "Either email or password is empty. Most of the functions will not work, unless those are added to each funtion calls"
            end
            @email = email
            @password = password
            @function_list = {  "ping" => {},
                                "availability_check" => {:args => ["email", "password", "domainname"] },
                                "register"  => {:args => ["email", "password", "domainname", "enduseremail"], :opt_args => [ "monthsofregistration", "nameserver", "forwardurl" ] },
                                "renew" => { :args => ["email", "password", "domainname"], :opt_args => ["monthsofregistration"] },
                                "host_registration" => { :args => ["email", "password", "hostname", "ipaddress"] },
                                "host_removal" => { :args => ["email", "password", "hostname"] }, 
                                "host_list" => { :args => ["email", "password", "domainname"] }, 
                                "modify" => { :args => ["email", "password", "domainname"], :opt_args => ["nameserver", "forwardurl"] }, 
                                "resend_email" => { :args => ["email", "password", "domainname"], :opt_args => ["enduseremail"] }, 
                                "domain_deactivate" => { :args => ["email", "password", "domainname", "reason"] }, 
                                "domain_reactivate" => { :args => ["email", "password", "domainname"] }, 
                                "update_parking" => { :args => ["email", "password", "domainname"], :opt_args => ["category", "keyword"]} }
                                # Extend function_list to add new API functions.
                                # :args -> Mandatory arguments, 
                                # :opt_args -> Optional arguments. 
                                
            init_functions()
        end

        def init_functions
            @functions = {}
            @function_list.each do |name, value|
                @functions[name] = APIFUNC.new( name, args = value[:args] ? value[:args] : {}, opt_args = value[:opt_args] ? value[:opt_args] : {} ) 
            end
        end
        
        def list_functions(detail = true)
            # Lists all the supported functions along with mandatory and optional
            # arguments, where relevant.
            i=0
            puts "Available API functions are"
            @functions.each do |key, value|
                i += 1
                print i, ". ",key, "\n"
                print "\tArguments:- ", value.args, "\n" if not value.args.empty?
                print "\tOptional Arguments:- ", value.opt_args, "\n" if not value.opt_args.empty? and detail
                puts
           end
        end
        
        def call_function(name, type, params = {})
           # Searches in function lists for function 'name' and calls the 
           # API function with params. 
           
            params = {} if not params.is_a? Hash
            params["email"] = @email if not params.has_key?("email")
            params["password"] = @password if not params.has_key?("password")

            return error_msg(type, ["Function not defined ", name] ) if not @functions.has_key?(name) 

            function = @functions[name]

            function.args.each do |value|
                if not params.has_key?(value)
                    return error_msg(type, [value, " not defined in input; Mandatory parameters are ", function.args.join(",")] )
                end
            end
            function.call(params, type=type)
        end
        
        def error_msg(type, str) 
            # Generates and returns the client side error messages in 
            # user-specified format
            if type == 'json'
                return '{"status":"NOT OK","reason":"'.concat(str.join()).concat('"}') 
            else
                xml = <<EOS 
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<dottk>
<status>NOT OK</status>
<reason></reason>
</dottk>
EOS
            doc = REXML::Document.new xml
            doc.elements["dottk"].elements["reason"].text = str.join()
            return doc.to_s
            end
        end
        
        def method_missing(*arg)
            # Parses the API function calls (ping, ping_xml, ping_json etc.) 
            # into name and type (ping, xml), and calls call_function. 
            
            name = arg[0].id2name
            type = "xml"
            
            if name =~ /_xml$/
                name.slice!(/\_xml$/)
            elsif name =~ /_json$/
                name.slice!(/_json$/)
                type = "json"
            end
            call_function(name, type, *arg[1,arg.size])
        end
        
    end
end
