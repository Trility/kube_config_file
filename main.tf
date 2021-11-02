variable "cluster_name" {}

provider "aws" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

resource "local_file" "kubeconfig" {
  content = templatefile("${path.module}/kubeconfig.tpl", {
    endpoint-url = data.aws_eks_cluster.cluster.endpoint
    base64-encoded-ca-cert = data.aws_eks_cluster.cluster.certificate_authority[0].data
    cluster-name = data.aws_eks_cluster.cluster.name
  })
  filename = pathexpand("~/kubeconfig-${var.cluster_name}")
}
