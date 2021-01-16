output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_name" {
  value = local.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "kube_config" {
  value = module.eks.kubeconfig
}

output "kube_auth" {
  value = module.eks.config_map_aws_auth
}

output "region" {
  value = "eu-central-1"
}
