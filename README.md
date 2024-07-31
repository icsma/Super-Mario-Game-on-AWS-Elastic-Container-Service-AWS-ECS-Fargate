# Projeto AWS ECS e ALB

Este projeto tem como objetivo estudar e implementar serviços na AWS utilizando Elastic Container Service (ECS), Elastic Kubernetes Service (EKS), e Application Load Balancer (ALB). Este repositório contém scripts e configurações para criar uma infraestrutura escalável e eficiente na AWS.

## Objetivo

Estudos e desenvolvimento pessoal com foco em adquirir conhecimento avançado e prático nas tecnologias AWS. O objetivo final é qualificar-se para acessar o curso do AWS Skill Builder e desenvolver habilidades essenciais para avançar profissionalmente na área de cloud computing.

## Tecnologias Utilizadas

- **AWS Elastic Container Service (ECS)**
- **AWS Elastic Kubernetes Service (EKS)**
- **AWS Application Load Balancer (ALB)**
- **Terraform** para infraestrutura como código
- **AWS CLI** para gerenciamento de serviços AWS

## Estrutura do Projeto

O projeto está organizado da seguinte forma:

├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── ecs-alb-configuration/
│ ├── ecs.tf
│ ├── alb.tf
│ ├── security-groups.tf
│ └── target-groups.tf
├── scripts/
│ ├── deploy.sh
│ ├── create-ecr-repo.sh
│ └── push-image.sh
├── README.md
└── .gitignore


