FROM jmeter-base:latest

COPY mongo-java-driver-3.11.0.jar apache-jmeter-5.1.1/lib/ext

COPY sampleData.json .

ENTRYPOINT apache-jmeter-5.1.1/bin/jmeter-server \
    -Dserver.rmi.localport=50000 \
    -Dserver_port=1099 \
    -Jserver.rmi.ssl.disable=true
