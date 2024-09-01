package itest

import (
	"io"
	"net/http"
	"os"
	"os/exec"
	"testing"
	"time"
)

var cmd *exec.Cmd

func TestMain(m *testing.M) {
	// Start the application
	cmd = exec.Command("go", "run", "../go-server/main.go")
	err := cmd.Start()
	if err != nil {
		panic(err)
	}

	// Wait for the application to start
	time.Sleep(10 * time.Second)

	// Run tests
	code := m.Run()

	// Stop the application
	cmd.Process.Kill()
	cmd.Wait()

	// Exit with the test code
	os.Exit(code)
}

func TestHelloEndpoint(t *testing.T) {
	resp, err := http.Get("http://localhost:9001/hello")
	if err != nil {
		t.Fatalf("Failed to send request: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		t.Errorf("Expected status code 200, got %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		t.Fatalf("Failed to read response body: %v", err)
	}

	expected := "hello world\n"
	if string(body) != expected {
		t.Errorf("Expected response body %q, got %q", expected, string(body))
	}
}
