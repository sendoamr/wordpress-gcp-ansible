import os
import logging

import googleapiclient.discovery

PROJECT = os.environ.get('PROJECT', None)
ZONE = os.environ.get('ZONE', None)
INSTANCE = os.environ.get('INSTANCE', None)

logger = logging.getLogger('star_ce')

compute = googleapiclient.discovery.build('compute', 'v1')

def function_handler(event, **kwargs):
    """
        Function that start compute engine instance
        :param event: Cloud Scheduler. <br/>
        :param context: function context <br/>
        :return: Nothing
    """

    logger.info('Processing: {}'.format(event))


    compute.instances().start(
        project=PROJECT,
        zone=ZONE,
        instance=INSTANCE).execute()

