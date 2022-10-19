import json
import logging


def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type\
    return {
            'statusCode': 200,
            'body': json.dumps("Hello World!")
    }

