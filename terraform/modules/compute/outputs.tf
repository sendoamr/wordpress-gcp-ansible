
output "ce_instance" {
  value       = google_compute_instance.wordpress.name
  description = "Instance name"
}
