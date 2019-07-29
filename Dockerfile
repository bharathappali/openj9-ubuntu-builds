FROM ubuntu:16.04

RUN apt-get update && mkdir -p /opt/java/openjdk

RUN set -eux; \
    apt-get install curl; \
    ARCH="$(uname -i)"; \
    case "${ARCH}" in \
       amd64|x86_64) \
         ESUM='e28fbe8628fe1949e3b766d90f36ab5d15ac77f4e0279f58da80de361a99d7aa'; \
         BINARY_URL='https://github.com/bharathappali/openj9-ubuntu-builds/raw/master/build/jdk11/x86_64/ubuntu16/openj9-jdk11-ubuntu.tar.gz'; \
         ;; \
         *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"
ENV JAVA_TOOL_OPTIONS="-XX:+IgnoreUnrecognizedVMOptions -XX:+UseContainerSupport -XX:+IdleTuningCompactOnIdle -XX:+IdleTuningGcOnIdle"
