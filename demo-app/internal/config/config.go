package config

import "os"

type Config struct {
	AWSRegion string
	Image     string
}

func Load() (*Config, error) {
	return &Config{
		AWSRegion: getEnv("AWS_REGION", "unknown"),
		Image:     getEnv("IMAGE_NAME", "local"),
	}, nil
}

func getEnv(key, defaultValue string) string {
	if val, exists := os.LookupEnv(key); exists {
		return val
	}
	return defaultValue
}
