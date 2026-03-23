variable "environments" {
  default     = ["dev"]
  description = "List of Kubernetes environments (clusters) to deploy"
  sensitive   = false
  type = list(string)
}