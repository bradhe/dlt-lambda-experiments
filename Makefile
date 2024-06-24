ARTIFACT_NAME ?= post-dlt-experiments.zip
ARTIFACT_PATH ?= ./bin/${ARTIFACT_NAME}
BUCKET_NAME ?= 

AWS_REGION ?= eu-central-1
AWS_PROFILE ?= bradhe

# NOTE: This needs to match the parameter in
# templates/cloudformation-lambda.yaml. Perhaps it should be passed in as a
# parameter?
FUNCTION_NAME ?= post-dlt-experiments

clean:
	rm -rf bin
	mkdir bin

build: clean
	pip install -r requirements.txt --target ./bin
	cp -R planner ./bin/planner
	cp func.py ./bin/func.py

package: build
	cd ./bin && zip -r ${ARTIFACT_NAME} ./*

${ARTIFACT_PATH}: package

deploy: ${ARTIFACT_PATH}
	aws s3 cp ${ARTIFACT_PATH} s3://${BUCKET_NAME}/${ARTIFAT_NAME} --region ${AWS_REGION} --profile ${AWS_PROFILE}
	aws lambda update-function-code \
		--function-name ${FUNCTION_NAME} \
		--s3-bucket ${BUCKET_NAME} \
		--s3-key ${ARTIFACT_NAME} \
		--profile ${AWS_PROFILE} \
		--region ${AWS_REGION}
