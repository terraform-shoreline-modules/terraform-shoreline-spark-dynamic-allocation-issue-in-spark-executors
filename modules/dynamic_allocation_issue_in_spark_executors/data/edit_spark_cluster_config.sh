

#!/bin/bash



# Define variables

SPARK_HOME=${PATH_TO_SPARK_HOME}

CLUSTER_CONFIG=${SPARK_CONFIG_FILE}

NEW_NUM_NODES=${NEW_NUMBER_OF_NODES}



# Stop the Spark cluster

${SPARK_HOME}/sbin/stop-all.sh



# Edit the cluster configuration to increase the number of nodes

sed -i "s/num_nodes=.*/num_nodes=${NEW_NUM_NODES}/g" ${CLUSTER_CONFIG}



# Start the Spark cluster

${SPARK_HOME}/sbin/start-all.sh