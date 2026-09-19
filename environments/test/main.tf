module "network" {
    source = "../../modules/network"
    environment = "test"
    service = "nginx"
}

module "application" {
    source = "../../modules/application"
    environment = "test"
    service = "nginx"
    vpc = module.network.vpc
    public_subnet_1 = module.network.public_subnet_1
    public_subnet_2 = module.network.public_subnet_2
    web_subnet_1 = module.network.web_subnet_1
}

module "database" {
    source = "../../modules/database"
    vpc = module.network.vpc
    public_subnet_1 = module.network.public_subnet_1
    public_subnet_2 = module.network.public_subnet_2
}