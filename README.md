
## Passo a Passo

### 1. Configurar a VPC

1. Criar uma nova Virtual Private Cloud (VPC).
2. Configurar quatro subnets: duas subnets públicas para acesso externo e duas subnets privadas para serviços internos.
3. Configurar três tabelas de roteamento: uma tabela de rota pública para as subnets públicas e duas tabelas de rota privadas para as subnets privadas.
4. Configurar um Internet Gateway e associá-lo à VPC para habilitar acesso à internet para as subnets públicas.
5. Configurar um NAT Gateway nas subnets públicas para permitir que instâncias nas subnets privadas acessem a internet de forma segura.

### 2. Configurar os Grupos de Segurança

1. Criar um grupo de segurança para o cluster ECS para permitir o tráfego de entrada e saída necessário.
2. Criar um grupo de segurança para o Application Load Balancer (ALB) para controlar o tráfego de entrada e saída do ALB.

### Abaixo alguns projetos futuros, para converte tudo para o terraform!!

### 3. Configurar o Application Load Balancer (ALB)

1. Criar um ALB e configurar listeners e target groups para distribuir o tráfego de entrada para as tasks do ECS que estão rodando nas subnets privadas.

### 4. Criar o Cluster ECS

1. Configurar um cluster ECS para gerenciar a aplicação containerizada.

### 5. Definir a Task Definition e os Serviços

1. Criar uma task definition para o jogo Super Mario, especificando a imagem Docker e os recursos necessários.
2. Configurar serviços ECS para rodar as tasks, associando-as aos target groups do ALB para balanceamento de carga.

### 6. Configurar o Amazon ECR

1. Criar um repositório no Amazon Elastic Container Registry (ECR).
2. Construir a imagem Docker para o jogo Super Mario e enviá-la para o repositório ECR.

### 7. Deploy do Serviço e Configuração do Auto Scaling

1. Criar serviços ECS adicionais para quaisquer componentes auxiliares ou microserviços necessários pelo jogo.
2. Configurar auto scaling para os serviços ECS para ajustar automaticamente o número de tasks em execução com base na demanda.


