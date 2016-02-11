#!/bin/bash

if [ -z "$CLUSTERED" ]; then
	# if not clustered then start it normally as if it is a single server
	/usr/sbin/rabbitmq-server -detached
else
	if [ -z "$CLUSTER_WITH" ]; then
		# If clustered, but cluster with is not specified then again start normally, could be the first server in the
		# cluster
		/usr/sbin/rabbitmq-server -detached
	else
		/usr/sbin/rabbitmq-server -detached
		rabbitmqctl stop_app
		if [ -z "$RAM_NODE" ]; then
			rabbitmqctl join_cluster rabbit@$CLUSTER_WITH
		else
			rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH
		fi
		rabbitmqctl start_app
	fi
fi

# wait for rabbitmq to start
sleep 10

# Set policy to mirror all queues to all nodes in the cluster.
rabbitmqctl set_policy ha-all "." '{"ha-mode":"all","ha-sync-mode":"automatic"}'

# Tail to keep the a foreground process active..
tail -f /var/log/rabbitmq/rabbit\@$HOSTNAME.log
