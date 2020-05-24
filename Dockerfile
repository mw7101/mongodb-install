FROM golang:latest AS builder
WORKDIR /go/src/github.com/mw7101/mongodb-install-arm/
RUN go get -d -v k8s.io/apimachinery/pkg/util/sets
COPY peer-finder.go .
RUN CGO_ENABLED=0 GOARCH=arm GOARM=7 go build -a -installsuffix cgo -o peer-finder .

FROM alpine:latest 
RUN apk --no-cache add ca-certificates wget bash bind-tools
COPY --from=builder /go/src/github.com/mw7101/mongodb-install-arm/peer-finder .
COPY install.sh .
RUN chmod +x install.sh peer-finder
EXPOSE 9376
ENTRYPOINT ["/install.sh"]


