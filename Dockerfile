# BUILD

FROM golang:1.16-alpine as BUILD

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
#COPY go.sum .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

ENV HTTP_PORT=8080
EXPOSE 8080

# MINIATURE

FROM scratch

COPY --from=BUILD /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=BUILD /app/reduce-docker-size /app/reduce-docker-size

ENTRYPOINT ["/app/reduce-docker-size"]
