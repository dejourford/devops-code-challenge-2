output "frontend_repo_url" {
  value = module.ecr.repository_urls["frontend"]
}

output "backend_repo_url" {
  value = module.ecr.repository_urls["backend"]
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
