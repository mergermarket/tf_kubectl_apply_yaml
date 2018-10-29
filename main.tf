data "aws_eks_cluster" "eks_cluster" {
  name = "jenkins-eks"
}

data "external" "aws_iam_authenticator" {
  program = ["python", "${path.module}/external_scripts/get_token.py"]

  query = {
    cluster = "${data.aws_eks_cluster.eks_cluster.id}"
  }
}

provider "kubernetes" {
  host                   = "${data.aws_eks_cluster.eks_cluster.endpoint}"
  cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)}"
  token                  = "${data.external.aws_iam_authenticator.result.token}"
  load_config_file       = false
}

data "template_file" "kubeconfig" {
  template = "${file("${path.module}/templates/kubeconfig.tpl")}"

  vars {
    cluster_name                      = "${data.aws_eks_cluster.eks_cluster.name}"
    kubeconfig_name                   = "jenkins"
    endpoint                          = "${data.aws_eks_cluster.eks_cluster.endpoint}"
    cluster_auth_base64               = "${data.aws_eks_cluster.eks_cluster.certificate_authority.0.data}"
    aws_authenticator_command         = "aws-iam-authenticator"
  }
}

resource "local_file" "kubeconfig" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "./kubeconfig"
}

resource "null_resource" "apply-yaml" {
  depends_on = ["local_file.kubeconfig"]
  triggers = {
    yaml_sha1 = "${sha1(file("${path.root}/${var.filename}"))}"
  }
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ./kubeconfig apply -f ${path.root}/${var.filename}"
  }
}


