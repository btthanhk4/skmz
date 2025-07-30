# 🔹 Build frontend bằng Node.js
FROM node:12.14 AS js_build
WORKDIR /webapp
COPY webapp /webapp
RUN npm install && npm run build

# 🔹 Build backend bằng Golang
FROM golang:1.13.6-alpine AS go_build
WORKDIR /server
COPY server /server
ENV GOPROXY=direct
RUN apk add --no-cache build-base git
RUN go mod download
RUN go build -o /go/bin/server

# 🔹 Final stage: chạy app
FROM alpine:3.11
WORKDIR /app
COPY --from=js_build /webapp/build ./webapp
COPY --from=go_build /go/bin/server ./server
CMD ["./server"]
