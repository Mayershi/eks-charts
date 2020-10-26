#!/usr/bin/env bash

PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$([[ $(uname -m) = "x86_64" ]] && echo 'amd64' || echo 'arm64')
GIT_REPO_ROOT=$(git rev-parse --show-toplevel)
BUILD_DIR="${GIT_REPO_ROOT}/build"
TOOLS_DIR="${BUILD_DIR}/tools"
mkdir -p "${TOOLS_DIR}"
export PATH="${TOOLS_DIR}:${PATH}"

HELMV2_VERSION="v2.16.9"
HELMV3_VERSION="v3.2.4"
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
KIND_VERSION=v0.5.1

## Install kubectl
curl -sSL "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o "${TOOLS_DIR}/kubectl"
chmod +x "${TOOLS_DIR}/kubectl"

## Install kubeval
curl -sSL https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-${PLATFORM}-${ARCH}.tar.gz | tar xz
mv kubeval "${TOOLS_DIR}/kubeval"

## Install helm v2
curl -sSL https://storage.googleapis.com/kubernetes-helm/helm-${HELMV2_VERSION}-${PLATFORM}-${ARCH}.tar.gz | tar xz
mv "${PLATFORM}-${ARCH}/helm" "${TOOLS_DIR}/helm"
rm -rf "${PLATFORM}-${ARCH}"

## Install helm v3
curl -sSL https://get.helm.sh/helm-${HELMV3_VERSION}-${PLATFORM}-${ARCH}.tar.gz | tar xz
mv "${PLATFORM}-${ARCH}/helm" "${TOOLS_DIR}/helmv3"
rm -rf "${PLATFORM}-${ARCH}"

## Initialize helm
helm init --client-only --kubeconfig="${BUILD_DIR}/.kube/kubeconfig"

## Install kind
curl -sSL "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-${PLATFORM}-${ARCH}" -o "${TOOLS_DIR}/kind"
chmod +x "${TOOLS_DIR}/kind"
