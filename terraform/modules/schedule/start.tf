
# zip up our source code
data "archive_file" "start_function_zip" {
  type        = "zip"
  output_path = "${path.root}/sources/start-v2.zip"
  source_dir  = "${path.root}/functions/start/"
}


resource "google_storage_bucket_object" "start_archive" {
  name   = "start.zip"
  bucket = var.temp-bucket
  source = "${path.root}/sources/start-v2.zip"
}

resource "google_cloudfunctions_function" "start_function" {
  name        = "start-function"
  description = "Start compute engine function"
  runtime     = "python37"
  entry_point = "function_handler"

  available_memory_mb   = 128
  source_archive_bucket = var.temp-bucket
  source_archive_object = google_storage_bucket_object.start_archive.name
  trigger_http          = true

  environment_variables = {
    PROJECT  = var.project_name
    ZONE     = var.zone
    INSTANCE = var.instance-name
  }

  labels = var.labels
}

resource "google_service_account" "start_service_account" {
  account_id   = "start-cloud-function-invoker"
  display_name = "Cloud Function Invoker Service Account"
}

resource "google_cloudfunctions_function_iam_member" "start_invoker" {
  project        = google_cloudfunctions_function.start_function.project
  region         = google_cloudfunctions_function.start_function.region
  cloud_function = google_cloudfunctions_function.start_function.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.start_service_account.email}"
}

resource "google_cloud_scheduler_job" "start_job" {
  name             = "start_function-scheduler"
  description      = "Trigger the ${google_cloudfunctions_function.start_function.name}"
  schedule         = "0 8 * * *"
  time_zone        = "Europe/Dublin"
  attempt_deadline = "320s"

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.start_function.https_trigger_url

    oidc_token {
      service_account_email = google_service_account.start_service_account.email
    }
  }
}