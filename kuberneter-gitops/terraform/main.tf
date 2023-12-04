locals {
  folder_id = "${var.FOLDER_ID}"
  subnet_id = "e9bevunssamm6atmvoam"
}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone = "${var.region}"
}

resource "yandex_kubernetes_cluster" "kurs" {
  name = "kurs"
  folder_id = local.folder_id
  network_id = "enp7dgjcatb3jgjij776"
  master {
    version = "1.25"
    public_ip = true
    zonal {
      zone      = "${var.region}"
      subnet_id = local.subnet_id
    }
  }
  service_account_id      = yandex_iam_service_account.myaccount.id
  node_service_account_id = yandex_iam_service_account.myaccount.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}

resource "yandex_iam_service_account" "myaccount" {
  name        = "myaccount"
  folder_id = local.folder_id
  description = "K8S zonal service account"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  # Сервисному аккаунту назначается роль "k8s.clusters.agent".
  folder_id = local.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = local.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = local.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "kms-key"
  folder_id = local.folder_id
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = local.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_kubernetes_node_group" "kurs" {
  cluster_id = yandex_kubernetes_cluster.kurs.id
  instance_template {
    name        = "infra-{instance.short_id}"
    platform_id = "standard-v3"
    resources {
      cores  = 6
      memory = 12
    }
    container_runtime {
     type = "containerd"
    }
    network_interface {
      ipv4               = true
      ipv6               = false
      nat                = true
      security_group_ids = []
      subnet_ids         = [local.subnet_id,]
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
}
