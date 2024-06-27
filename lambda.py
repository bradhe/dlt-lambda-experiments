import os
import json
import dlt
from pipeline import s3_resource

#if not os.environ["OPENAI_API_KEY"]:
#	raise RuntimeError("Please set your OpenAI API key")

def lambda_handler(event, context):
    # specify the pipeline name, destination and dataset name when configuring pipeline,
    # otherwise the defaults will be used that are derived from the current script name
    pipeline = dlt.pipeline(
        pipeline_name='s3',
        destination='motherduck',
        dataset_name='s3_data',
    )

    data = list(s3_resource())

    # print the data yielded from resource
    print(data)

    # run the pipeline with your parameters
    # load_info = pipeline.run(source())

    # pretty print the information on data that was loaded
    # print(load_info)
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({}),
    }

# NOTE: This is provided for testing purposes only. Should likely be removed,
# I'd say, in the end. Or maybe covered with actual test coverage.
if __name__ == "__main__":
    print(lambda_handler(None, None))
