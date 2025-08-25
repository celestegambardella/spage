# Default task - builds the project
default: build

# Build the spage binary
build:
    @echo "Building spage..."
    go build .

# Install the spage binary
install:
    @echo "Installing spage..."
    go install .

# Run tests
test:
    @echo "Running tests..."
    go test ./...

# Run the spage binary with arguments
run *args:
    ./spage {{args}}

# Clean build artifacts
clean:
    @echo "Cleaning up..."
    rm -f spage
