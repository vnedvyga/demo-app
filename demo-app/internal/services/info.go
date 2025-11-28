package services

import (
	"github.com/vnedvyga/demo-app/demo-app/internal/config"
)

type InfoService struct {
	cfg *config.Config
}

type InfoResponse struct {
	AWSRegion string `json:"aws_region"`
	Image     string `json:"image"`
}

func NewInfoService(cfg *config.Config) *InfoService {
	return &InfoService{cfg}
}

func (svc *InfoService) Info() InfoResponse {
	return InfoResponse{
		AWSRegion: svc.cfg.AWSRegion,
		Image:     svc.cfg.Image,
	}
}
