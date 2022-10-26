CONTAINER_NAME=localstack
TFPATH="infrastructure/environments/local"
CODEPATH="services/"

clean:
	rm -rf infrastructure/environments/local/.terraform/* infrastructure/environments/local/terraform.tfstate*
pull:
	docker pull localstack/localstack
	docker pull localstack/localstack-full
start: #stop
	docker-compose up -d
stop:
	docker container stop ${CONTAINER_NAME}
	docker container rm ${CONTAINER_NAME}
status:
	localstack status services
docker-logs:
	docker logs -f ${CONTAINER_NAME}
init:
	cd ${TFPATH} && tflocal init
apply: init compile-locker
	cd ${TFPATH} && tflocal apply
destroy:
	cd ${TFPATH} && tflocal destroy
compile-locker:
	cd ${CODEPATH}/locker && go build
locker-invoke:
	awslocal lambda invoke --function-name local-locker out --log-type Tail
locker-logs:
	awslocal logs tail /aws/lambda/local-locker
start-stepfn-execution:
	awslocal stepfunctions start-execution --state-machine-arn "arn:aws:states:us-east-1:000000000000:stateMachine:testing-step-functions"