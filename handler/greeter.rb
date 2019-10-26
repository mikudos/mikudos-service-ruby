class GreeterServer
    # list_schedule implements the ListSchedule rpc method.
    def list_schedule(hello_req, _unused_call)
        GRPC.logger.info('===== list_schedule =====')
        puts hello_req.name
        Schedule::Schedule.new(message: "Hello #{hello_req.name}")
    end
end