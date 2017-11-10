""" Kinesis Firehose Processing Logic """
from __future__ import print_function
import json
from base64 import b64decode, b64encode


STATUS_OK = 'Ok'
STATUS_DROPPED = 'Dropped'
STATUS_FAIL = 'ProcessingFailed'

class DroppedRecordException(Exception):
    """ Raise this if a record needs to be skipped/dropped """

def lambda_handler(event, context):
    """ Lambda entrypoint """
    print("Event: %s" % event)
    return {
        'records': map(process_record, event['records']),
    }

def process_record(record):
    """
        Invoked once for each record (raw base64-encoded data).
        Note: each processed record should contain a 'result' field
              with the corresponding status (ok, fail, dropped)
    """
    print("Processing record: %s" % record)
    data = json.loads(b64decode(record['data']))
    try:
        # eventually manipulate record
        new_data = transform_data(data)
        # re-encode and add newline (for Athena)
        record['data'] = b64encode(json.dumps(new_data) + "\n")
    except DroppedRecordException:
        record['result'] = STATUS_DROPPED
    except Exception:
        record['result'] = STATUS_FAIL
    else:
        record['result'] = STATUS_OK
    return record

def transform_data(data):
    """
        Invoked once for each record.
        Input: decoded data
        Output: manipulated data
    """
    print("Processing data: %s" % data)

    # example: you can skip records
    # if 'nsfw' in data:
    #     raise DroppedRecordException()

    # example: you can add new fields
    # data['new_value'] = True

    # return the transformed data dictionary
    return data
