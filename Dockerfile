# Build Geth in a stock Go builder container
FROM golang:1.14-alpine as builder

ARG UPSTREAM_VERSION

RUN apk add --no-cache make gcc musl-dev linux-headers git && \
    git clone -b ${UPSTREAM_VERSION} https://github.com/ethereum/go-ethereum.git && \
    cd go-ethereum && make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go/go-ethereum/build/bin/geth /usr/local/bin

ENTRYPOINT geth --datadir /goerli --goerli --rpc --rpcaddr 0.0.0.0 --rpccorsdomain "*" --rpcvhosts "*" --ws --wsorigins "*" --wsaddr 0.0.0.0 $EXTRA_OPTS



