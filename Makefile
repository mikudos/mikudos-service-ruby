NAME := language_master_learn_srv
SERVICE_VERSION := 0.0.1
PORT := 50051

.PHONY: update-proto
update-proto:
	./update_proto.sh

.PHONY:server
server:
	bundle exec ./server.rb

.PHONY: proto
proto:
	grpc_tools_ruby_protoc -I ./proto --ruby_out=lib --grpc_out=lib ./proto/**/*.proto

.PHONY:docker
docker:
	docker build . -t asia.gcr.io/kubenetes-test-project-249803/$(NAME):$(SERVICE_VERSION)

.PHONY:run-docker
run-docker:
	docker run -p $(PORT):$(PORT) --env BROKER_ADDRESSES=192.168.12.146:9092 asia.gcr.io/kubenetes-test-project-249803/$(NAME):$(SERVICE_VERSION)

.PHONY:push
push:
	docker push asia.gcr.io/kubenetes-test-project-249803/$(NAME):$(SERVICE_VERSION)

.PHONY: run-client
run-client:
	grpcc --proto ./proto/learn/learn.proto --address 127.0.0.1:$(PORT) -i
	# let ee = client.sayHello({name:"yue"}, printReply)