FROM python:3.8.15-slim-bullseye

ARG KUBE_VERSION="v1.23.3"
ARG HELM_VERSION="3.0.0"

RUN echo "HELM_VERSION is set to: ${HELM_VERSION}"

ENV FILENAME="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

RUN apt-get update -y && apt-get install ca-certificates jq git openssl curl -y && update-ca-certificates \
    && apt-get install busybox -y && ln -s /bin/busybox /usr/bin/[[ \
    && pip install yq \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl -L https://get.helm.sh/${FILENAME} -o /tmp/${FILENAME} \
    && tar -zxvf /tmp/${FILENAME} -C /tmp \
    && mv /tmp/linux-amd64/helm /bin/helm \
    # Cleanup uncessary files
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN bash -c 'if [[ "${HELM_VERSION}" == 2* ]]; then helm init --client-only; else echo "using helm3, no need to initialize helm"; fi'
WORKDIR /config

CMD bash
