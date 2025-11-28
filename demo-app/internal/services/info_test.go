package services

import (
	"os"
	"testing"

	"github.com/vnedvyga/demo-app/demo-app/internal/config"
)

func TestInfo(t *testing.T) {
	want := InfoResponse{"dummy_region", "dummy_image"}

	os.Setenv("AWS_REGION", want.AWSRegion)
	os.Setenv("IMAGE_NAME", want.Image)
	defer os.Unsetenv("AWS_REGION")
	defer os.Unsetenv("IMAGE_NAME")

	cfg, err := config.Load()
	if err != nil {
		t.Fatalf("Error loading config: %v", err)
	}

	service := NewInfoService(cfg)

	got := service.Info()

	if got != want {
		t.Errorf("got %v but want %v", got, want)
	}
}
