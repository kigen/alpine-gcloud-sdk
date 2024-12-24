FROM alpine:3.18.4

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="alpine-gcloud-sdk" \
      org.label-schema.description="gcloud SDK Image based on Alpine distro" \
      org.label-schema.url="https://www.254bit.com/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/kigen/alpine-gcloud-sdk" \
      org.label-schema.vendor="254Bit" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="0.1.0"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Set JAVA_HOME and update PATH
ENV JAVA_HOME /usr/lib/jvm/
ENV PATH $PATH:/usr/lib/jvm/bin

# Set Google Cloud SDK environment variables
ENV HOME=/ \
    CLOUDSDK_PYTHON_SITEPACKAGES=1 \
    PATH=/google-cloud-sdk/bin:$PATH

# Install dependencies and Google Cloud SDK
RUN echo "ipv6" >> /etc/modules && \
    apk update && \
    apk --no-cache add \
        bash \
        openssh-client \
        git \
        openssh \
        postgresql-libs \
        py-pip \
        gcc \
        python3 \
        python3-dev \
        musl-dev \
        postgresql-dev \
        make \
        curl \
        ca-certificates \
        unzip \
        wget \
        openssl && \
    update-ca-certificates && \
    wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.17%2B8/OpenJDK11U-jdk_x64_alpine-linux_hotspot_11.0.17_8.tar.gz && \
    tar zxvf OpenJDK11U-jdk_x64_alpine-linux_hotspot_11.0.17_8.tar.gz && \
    mv jdk-11.0.17+8/ /usr/lib/jvm/ && \
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && \
    unzip google-cloud-sdk.zip && \
    rm google-cloud-sdk.zip && \
    google-cloud-sdk/install.sh \
        --usage-reporting=true \
        --path-update=true \
        --bash-completion=true \
        --rc-path=/.bashrc \
        --additional-components alpha app-engine-go app-engine-java app-engine-python beta bigtable bq cloud-datastore-emulator docker-credential-gcr gsutil kubectl pubsub-emulator && \
    apk del ca-certificates unzip wget openssl gcc python3-dev musl-dev postgresql-dev make && \
    rm -rf /var/cache/apk/* && \
    google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true && \
    sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json && \
    mkdir /.ssh

VOLUME ["/.config"]
