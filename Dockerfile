# Use the official Golang image to create a build artifact.
FROM golang:alpine AS builder

# Set the Current Working Directory inside the container.
WORKDIR /app

# Print out what step is currently running.
RUN echo "Copying go.mod and go.sum files..."
COPY go.mod ./

# Print out what step is currently running.
RUN echo "Downloading dependencies..."
RUN go mod download

# Print out what step is currently running.
RUN echo "Copying the source code..."
COPY . .

# Print out what step is currently running.
RUN echo "Building the Go app..."
RUN go build -o main .

# Start a new stage from scratch.
FROM alpine:latest

WORKDIR /root/

# Print out what step is currently running.
RUN echo "Copying the pre-built binary file..."
COPY --from=builder /app/main .

# Command to run the executable.
CMD ["./main"]