FROM debian:bookworm-20221114


ARG KUBE_VERSION="v1.23.3"

ARG HELM_VERSION="3.0.0"

RUN echo "HELM_VERSION is set to: ${HELM_VERSION}"

ENV FILENAME="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

RUN apt-get update -y && apt-get install ca-certificates -y && update-ca-certificates \
    && apt-get install curl -y \
    && apt-get install bash -y \
    && apt-get install jq -y \
    && apt-get install python3 -y \
    && apt-get install make -y \
    && apt-get install git -y \
    && apt-get install openssl -y \
    && apt-get install python3-pip -y \
    && pip install yq \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl -L https://get.helm.sh/${FILENAME} -o /tmp/${FILENAME} \
    && tar -zxvf /tmp/${FILENAME} -C /tmp \
    && mv /tmp/linux-amd64/helm /bin/helm \
    # Cleanup uncessary files
    && rm -rf /var/cache/apt/* \
    && rm -rf /tmp/*

RUN bash -c 'if [[ "${HELM_VERSION}" == 2* ]]; then helm init --client-only; else echo "using helm3, no need to initialize helm"; fi'
WORKDIR /config

CMD bash
