terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_kubernetes_cluster" "dz9" {
  name = "dz9"
  network_id = "enp7dgjcatb3jgjij776"
  master {
    public_ip = true
    zonal {
      zone      = "ru-central1-a"
      subnet_id = "e9bevunssamm6atmvoam"
    }
  }
  service_account_id      = "aje561igq2ri2167gtst"
  node_service_account_id = "aje561igq2ri2167gtst"
}

resource "yandex_kubernetes_node_group" "dz9" {
  cluster_id = yandex_kubernetes_cluster.dz9.id
  name       = "dz9"
  instance_template {
    name        = "infra-{instance.short_id}"
    platform_id = "standard-v3"
    resources {
      cores  = 2
      memory = 8
    }
    container_runtime {
     type = "containerd"
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
}

resource "yandex_kubernetes_node_group" "dz9-def" {
  cluster_id = yandex_kubernetes_cluster.dz9.id
  name       = "dz9-def"
  instance_template {
    name        = "default-{instance.short_id}"
    platform_id = "standard-v3"
    resources {
      cores  = 2
      memory = 8
    }
    container_runtime {
     type = "containerd"
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
}
