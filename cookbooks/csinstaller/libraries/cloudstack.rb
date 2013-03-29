#
# Author:: Chirag Jog <chirag@clogeny.com>
# Copyright:: Copyright (c) 2013, Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


begin
  require 'rubygems'
  require 'base64'
  require 'openssl'
  require 'uri'
  require 'cgi'
  require 'net/http'
  require 'json'
end

module Opscode
  module Cloudstack
    ASYNC_POLL_INTERVAL = 5.0
    ASYNC_TIMEOUT = 600
    module Admin

      def get_zone_id(zone_name)
        zones = send_request({"command" => "listZones"})["zone"]
        return zones.find { |z| z["name"] == zone_name }["id"]
      end

      def send_request(params, admin_api_url="http://localhost:8096")
        params['response'] = 'json'
        params_arr = []
        params.sort.each { |elem|
          params_arr << elem[0].to_s + '=' + elem[1].to_s
        }
        data = params_arr.join('&')
        Chef::Log.debug("Raw HTTP Request: #{data}")
        #encoded_data = URI.encode(data.downcase).gsub('+', '%2B').gsub(',', '%2c').gsub(' ','%20').gsub('/','%2F').gsub(':',"%3A")
        #Chef::Log.info("Encoded HTTP Request: #{encoded_data}")
        url = "#{admin_api_url}?#{data}"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        Chef::Log.debug("HTTP Request: #{uri.request_uri}")
        response = http.request(request)
        Chef::Log.debug("HTTP Response: #{response.body}")

        if !response.is_a?(Net::HTTPOK) then
          Chef::Log.info("Error #{response.code}: #{response.message}")
          Chef::Log.info(JSON.pretty_generate(JSON.parse(response.body)))
          Chef::Log.info("URL: #{url}")
          exit 1
        end
        json = JSON.parse(response.body)
        json[params['command'].downcase + 'response']
      end
    def send_async_request(params, admin_api_url="http://localhost:8096")
          json = send_request(params,admin_api_url)

          params = {
              'command' => 'queryAsyncJobResult',
              'jobId' => json['jobid']
          }
          max_tries = (ASYNC_TIMEOUT / ASYNC_POLL_INTERVAL).round
          max_tries.times do
            json = send_request(params, admin_api_url)
            status = json['jobstatus']
            print "."
            if status == 1 then
              return json['jobresult']
            elsif status == 2 then
              print "\n"
              Chef::Log.info("Request failed (#{json['jobresultcode']}): #{json['jobresult']}")
              exit 1
            end
            STDOUT.flush
            sleep ASYNC_POLL_INTERVAL
          end
          print "\n"
          Chef::Log.info("Error: Asynchronous request timed out")
          exit 1
        end
      end
    end
  end
