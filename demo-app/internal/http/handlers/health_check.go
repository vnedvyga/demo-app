package handlers

import (
	"encoding/json"
	"net/http"
)

type HealthCheckHandler struct {
}

type HealthResponse struct {
	Status  string `json:"status"`
	Message string `json:"message"`
}

func NewHealthCheckHandler() *HealthCheckHandler {
	return &HealthCheckHandler{}
}

func (h *HealthCheckHandler) Get(w http.ResponseWriter, r *http.Request) {
	healthResponse := HealthResponse{
		Status:  "OK",
		Message: "Everythin is good",
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(healthResponse)
}
