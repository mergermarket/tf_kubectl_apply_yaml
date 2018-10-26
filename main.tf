data "aws_eks_cluster" "eks_cluster" {
  name = "jenkins-eks"
}

data "external" "aws_iam_authenticator" {
  program = ["${path.module}/external_scripts/get_token.sh"]

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

//# Sample code for setting up a trigger based on changes to
//
# the actual resources.
//# Not working 100% as it triggers when resource has just
//# been created
//data "external" "kubernetes-dashboard-role" {
//  program = ["${path.module}/external_scripts/describe_object.sh"]
//  query = {
//    type      = "rolebindings"
//    name      = "kubernetes-dashboard-minimal"
//    namespace = "kube-system"
//  }
//}

resource "null_resource" "apply-yaml" {
  triggers = {
    yaml_sha1 = "${sha1(file("${path.root}/${var.filename}"))}"
//    resource_sha1 = "${sha1(lookup(data.external.kubernetes-dashboard-role.result, "roles", ""))}"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.root}/${var.filename}"
  }
}
