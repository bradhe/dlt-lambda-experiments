# :test_tube: dltHub + AWS Lambda experiments

This repository contains the boilerplate and a bit of code that will allow for
experimentation with dltHub and AWS Lambda. The goal is to try invoking and
using it in a variety of different scenarios to demonstrate how easy (or not)
it is to get started with AWS Lambda and dlt.

## Deployment

To effectively run these experiments you need to launch two stacks (in order!).

1. **Artifacts stack** is the stack where the code is hosted. AWS Lambda will
   look in here to find the code to execute.
1. **Lambda stack** is the stack that configures AWS Lambda and how/when to
   invoke it.

**Note:** You must launch the Artifacts stack first *and* deploy code (using
`make deploy` in this directory), otherwise launching the Lambda stack will
fail and you will be confused!

### Artifacts stack

The application artifacts (e.g. the results of `make package`) need to be
deployed into a bucket such that Lambda picks them up. A cloudformation
template for that stack lives in the `./templates` directory. To create the
artifacts stack, you need to do the following:

```bash
aws cloudformation create-stack \
		--stack-name dlt-experiments-artifacts-1 \
		--template-body file://./templates/cloudformation-artifacts.yaml \
		--profile my-profile \
		--region eu-central-1 \
		--capabilities CAPABILITY_IAM
```

You can monitor it's progress using the CLI.

```bash
$ aws cloudformation describe-stacks \
		--stack-name dlt-experiments-artifacts-1 \
		--profile my-profile \
		--region eu-central-1
```

### Lambda stack

**NOTE:** When you are creating the Lambda stack for the first time you will
need to make sure the package exists in S3 first.

```bash
aws cloudformation create-stack \
		--stack-name dlt-experiments-lambda-1 \
		--template-body file://./templates/cloudformation-lambda.yaml \
        --parameters ParameterKey=ArtifactsStackName,ParameterValue=dlt-experiments-artifacts-1 \
		--profile my-profile \
		--region eu-central-1 \
		--capabilities CAPABILITY_IAM
```

You can monitor it's progress using the CLI.

```bash
$ aws cloudformation describe-stacks \
		--stack-name dlt-experiments-lambda-1 \
		--profile my-profile \
		--region eu-central-1
```
