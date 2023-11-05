# Consumer

## Kafka 설치

```sh

    ## update
    yum update -y

    ## kafka를 위한 java설치
    yum install -y java-1.8.0-openjdk-devel.x86_64

    ## Kafka 설치
    wget https://downloads.apache.org/kafka/3.6.0/kafka_2.13-3.6.0.tgz
    tar -xvf kafka_2.13-3.6.0.tgz
    ln -s kafka_2.13-3.6.0 kafka
```

## 2. 서비스 등록

```sh
    ## Zookeeper Service 등록
    ## Kafka Service 등록

    ## 서비스 등록 (zookeeper.service)
    systemctl start zookeeper.service
    systemctl status zookeeper.service

    ## 서비스 등록 (kafka.service)
    systemctl start kafka.service
    systemctl status kafka.service

    sudo netstat -anp | egrep "9092|2181"
```

## 3. topic 설치

```sh

    ## topic 설치
    bin/kafka-topics.sh --create --topic twitter --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092  &
    bin/kafka-topics.sh --create --topic sendbird --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092  &
    bin/kafka-topics.sh --create --topic google --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092  &

    ## topic 확인
    bin/kafka-topics.sh --list --bootstrap-server localhost:9092

    ## Consumer 등록
    ./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic twitter --from-beginning
```
