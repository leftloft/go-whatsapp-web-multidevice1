############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder
RUN apk update && apk add --no-cache vips-dev gcc musl-dev gcompat ffmpeg
WORKDIR /whatsapp3
COPY ./src .

# Fetch dependencies.
RUN go mod download
# Install pkger
RUN go install github.com/markbates/pkger/cmd/pkger@latest
# Build the binary.
RUN pkger && go build -o /app/whatsapp3

#############################
## STEP 2 build a smaller image
#############################
FROM alpine
RUN apk update && apk add --no-cache vips-dev ffmpeg
WORKDIR /app
# Copy compiled from builder.
COPY --from=builder /app/whatsapp3 /app/whatsapp3
# Run the binary.
ENTRYPOINT ["/app/whatsapp3"]
