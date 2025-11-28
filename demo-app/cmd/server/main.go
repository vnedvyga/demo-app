package main

import (
	"log"
	"net/http"

	"github.com/vnedvyga/demo-app/demo-app/internal/config"
	"github.com/vnedvyga/demo-app/demo-app/internal/http/handlers"
	"github.com/vnedvyga/demo-app/demo-app/internal/http/router"
	"github.com/vnedvyga/demo-app/demo-app/internal/services"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatal(err)
	}

	infoService := services.NewInfoService(cfg)
	infoHandler := handlers.NewInfoHandler(infoService)

	errorHandler := handlers.NewErrorHandler()
	healthCheckHandler := handlers.NewHealthCheckHandler()

	r := router.NewRouter(infoHandler, errorHandler, healthCheckHandler)

	log.Println("Server starting on :8080")
	if err := http.ListenAndServe(":8080", r); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
