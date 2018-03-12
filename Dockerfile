FROM alpine:3.6


ARG KUBE_VERSION="v1.8.1"

ARG HELM_VERSION="v2.7.0"

ENV FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"

RUN apk add --update ca-certificates && update-ca-certificates \
    && apk add --update -t deps curl \
    && apk add bash \
    && apk add jq \
    && apk add python \
    && apk add make \
    && apk add git \
    && apk add openssl \
    && apk add py-pip \
    && pip install yq \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl -L http://storage.googleapis.com/kubernetes-helm/${FILENAME} -o /tmp/${FILENAME} \
    && tar -zxvf /tmp/${FILENAME} -C /tmp \
    && mv /tmp/linux-amd64/helm /bin/helm \
    # Cleanup uncessary files
    && apk del --purge deps \
    && rm /var/cache/apk/* \
    && rm -rf /tmp/*

RUN helm init --client-only
WORKDIR /config

CMD bash
