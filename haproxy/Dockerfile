FROM haproxy:1.5

RUN apt-get update && apt-get install -y rsyslog vim --no-install-recommends

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY 49-haproxy.conf /etc/rsyslog.d/49-haproxy.conf

CMD rsyslogd && haproxy -f /usr/local/etc/haproxy/haproxy.cfg && sleep 5  && tail -f /var/log/haproxy*.log

EXPOSE 15670
EXPOSE 5670
EXPOSE 8100
