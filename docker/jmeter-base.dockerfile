FROM amazonlinux:latest

RUN yum update -y \
    && yum install -y sudo wget tar\
    && sudo yum install java-1.8.0-openjdk-devel-1.8.0.222.b10-0.amzn2.0.1 -y \
    && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.1.1.tgz \
    && tar -xf apache-jmeter-5.1.1.tgz \
    && rm apache-jmeter-5.1.1.tgz \
    && rm apache-jmeter-5.1.1/lib/mongo-java-driver-2.11.3.jar