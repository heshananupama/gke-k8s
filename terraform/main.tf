provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "minimal" {
  name     = var.cluster_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
   logging_config {
    enable_components = [] # ✅ disables logging agents like fluentbit
  }

  monitoring_config {
    enable_components = [] # ✅ disables gke-metrics-agent, metrics-server
  }
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "UNSPECIFIED" # ✅ Avoid enabling auto features
  }

  addons_config {
    http_load_balancing {
      disabled = true # ✅ disables l7-default-backend
    }

    horizontal_pod_autoscaling {
      disabled = true # ✅ disables metrics-server
    }

 

    network_policy_config {
      disabled = true
    }
  }

}

resource "google_container_node_pool" "minimal_nodes" {
  name     = "worker-pool"
  cluster  = google_container_cluster.minimal.name
  location = var.region
  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }

  
  node_config {
    machine_type = "e2-small"
    disk_size_gb = 30               # ✅ reduce from default 100GB
    disk_type    = "pd-standard"    # ✅ use standard instead of SSD if you want
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  initial_node_count = 1
}

