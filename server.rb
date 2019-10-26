#!/usr/bin/env ruby

this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'config'
require 'socket'
require 'grpc_kit'
require 'pry'
require 'schedule/schedule_services_pb'

Config.setup do |config|
    config.const_name = 'Settings'
    config.use_env = true
    config.env_prefix = 'RUBY_ENV'
    config.env_separator = '__'
    config.env_converter = :downcase
    config.env_parse_values = true
end
Config.load_and_set_settings(Config.setting_files("./config", ENV['RUBY_ENV']))
# GreeterServer is simple server that implements the Schedule ScheduleService server.
class GreeterServer < Schedule::ScheduleService::Service
    def initialize
        @cookies = [
            'People are naturally attracted to you.',
            'You learn from your mistakes... You will learn a lot today.'
        ]
    end
end

# main starts an RpcServer that receives requests to GreeterServer at the sample
# server port.
def main
    sock = TCPServer.new(Settings.port)
    server = GrpcKit::Server.new
    server.handle(GreeterServer.new)
    puts "GRPC server started at #{Settings.port}"

    loop do
        conn = sock.accept
        server.run(conn)
    end
end

require './handler/greeter'

main