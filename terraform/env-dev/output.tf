
output "alb-dns" {
  description = "The ALB dns endpoint to test the service"
  value       = module.tp-devops-test.alb-dns
}