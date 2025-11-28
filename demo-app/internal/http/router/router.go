package router

import (
	"net/http"

	"github.com/vnedvyga/demo-app/demo-app/internal/http/handlers"
)

func NewRouter(infoHandler *handlers.InfoHandler, errorHandler *handlers.ErrorHandler, healthCheckHandler *handlers.HealthCheckHandler) http.Handler {
	mux := http.NewServeMux()

	mux.HandleFunc("/", infoHandler.Get)
	mux.HandleFunc("/error", errorHandler.Get)
	mux.HandleFunc("/healthz", healthCheckHandler.Get)

	return mux
}
