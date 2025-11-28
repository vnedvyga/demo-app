# Build stage
FROM golang:1.25 AS build

WORKDIR /app

COPY . .

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o server ./cmd/server

# Final image
FROM scratch

COPY --from=build /app/server /server

USER 5000

EXPOSE 8080

CMD ["/server"]
