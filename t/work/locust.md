Run locust swarm in distributed mode
====================================

On master:

   locust -f TEST_FILE --host HOST --port WEB_PORT --master 

On slave:

   locust -f TEST_FILE --host HOST --slave --master-host=MASTER_HOST_NAME
