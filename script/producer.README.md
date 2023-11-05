# Producer

## Kafka 설치

```sh

    sudo yum update -y

    sudo yum install -y java-11-amazon-corretto-headless
    sudo yum install -y java-11-amazon-corretto

    java -version

    wget https://dlcdn.apache.org/kafka/3.6.0/kafka_2.12-3.6.0.tgz
    tar -xvf kafka_2.12-3.6.0.tgz
    ln -s kafka_2.12-3.6.0 kafka
```

## Twitter Producer 쏘기

```sh
    bin/kafka-console-producer.sh --topic twitter --bootstrap-server [private-ip]:9092
```
