FROM alpine:3.6


ARG KUBE_VERSION="v1.14.3"

ARG HELM_VERSION="v2.12.3"

RUN echo "HELM_VERSION is set to: ${HELM_VERSION}"

ENV FILENAME="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

RUN apk add --update ca-certificates && update-ca-certificates \
    && apk add --update curl \
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
    && curl -L https://get.helm.sh/${FILENAME} -o /tmp/${FILENAME} \
    && tar -zxvf /tmp/${FILENAME} -C /tmp \
    && mv /tmp/linux-amd64/helm /bin/helm \
    # Cleanup uncessary files
    && rm /var/cache/apk/* \
    && rm -rf /tmp/*

RUN bash -c 'if [[ "${HELM_VERSION}" == 2* ]]; then helm init --client-only; else echo "using helm3, no need to initialize helm"; fi'
WORKDIR /config

CMD bash
