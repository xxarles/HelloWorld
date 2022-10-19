output "base_url" {
  value = "${module.Lambda.url}"
}

output "api_key" {
  value = "${module.Lambda.key}"
  sensitive = true
}