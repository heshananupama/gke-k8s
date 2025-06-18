variable "project_id" {
  type        = string
  description = "GCP Project ID"
  default = "hip-courier-463315-k1"
}

variable "region" {
  type        = string
  default     = "northamerica-northeast2-c"
  description = "GCP Region"
}

variable "cluster_name" {
  type        = string
  default     = "flux-learning-cluster"
  description = "GKE Cluster Name"
}
