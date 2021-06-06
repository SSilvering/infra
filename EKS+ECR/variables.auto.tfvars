aws_region         = "eu-central-1"
cluster-name       = "cluster-1"
node-group-name    = "cluster-node-1"
instance_types     = "t3.large" # up to 35 pods per node
scaling-desired    = 2
scaling-max        = 2          # (node-per-node * max) = overal avaliable node
scaling-min        = 2
ecr-repo-name      = "chat"
ecr-tag-mutability = "MUTABLE"
scan-on-push       = true
subnet-count       = 2