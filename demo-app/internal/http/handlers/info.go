package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/vnedvyga/demo-app/demo-app/internal/services"
)

type InfoHandler struct {
	Service *services.InfoService
}

func NewInfoHandler(svc *services.InfoService) *InfoHandler {
	return &InfoHandler{svc}
}

func (h *InfoHandler) Get(w http.ResponseWriter, r *http.Request) {
	data := h.Service.Info()

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(data)
}
