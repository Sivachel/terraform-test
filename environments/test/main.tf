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
    public_subnet_3 = module.network.public_subnet_3
    web_subnet_1 = module.network.web_subnet_1
    web_subnet_2 = module.network.web_subnet_2
    web_subnet_3 = module.network.web_subnet_3
}

module "database" {
    source = "../../modules/database"
    vpc = module.network.vpc
    database_subnet_1 = module.network.database_subnet_1
    database_subnet_2 = module.network.database_subnet_2
    database_subnet_3 = module.network.database_subnet_3
    ecs-sgrp = module.application.ecs-sgrp
}
