module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.18"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    public = {
      subnets          = module.vpc.public_subnets
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1

      instance_type = "t2.small"
      k8s_labels = {
        Environment = "demo"
        App         = "Echo-server"
      }
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
