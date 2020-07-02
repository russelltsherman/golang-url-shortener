FROM golang:1.12-buster as builder
ENV GO111MODULE=on
WORKDIR /go/src/github.com/aptdeco/hypokorisma/
COPY . .

RUN go mod tidy
RUN apt update && apt install -y nodejs npm
RUN npm install -g yarn
RUN make build

# upx stuff
FROM gruebel/upx:latest as upx
COPY --from=builder /go/src/github.com/aptdeco/hypokorisma/releases/hypokorisma_linux_amd64/hypokorisma /hypokorisma.org
RUN upx --best --lzma -o /hypokorisma /hypokorisma.org

FROM debian:buster
RUN useradd --create-home app
WORKDIR /home/app
COPY --from=upx /hypokorisma .
COPY config/example.yaml ./config.yaml
RUN chown -R app: .
USER app

EXPOSE 8080

VOLUME ["/data"]

CMD ["/home/app/hypokorisma"]