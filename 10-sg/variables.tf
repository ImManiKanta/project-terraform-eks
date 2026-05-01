variable "project" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "sg_names" {
    type = list
    default = [
        # Databases
        "mongodb", "redis", "mysql", "rabbitmq",
        # ingress ALB
        "ingress_alb",
        # Bastion
        "bastion"
    ]
}