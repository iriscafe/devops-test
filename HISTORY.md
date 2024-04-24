# Comentários e Aprimoramentos

## Objetivo:
- Desenvolver e administrar um ambiente Kubernetes altamente eficaz na AWS, seguindo as melhores práticas de DevOps.

Fluxograma que idealizei:
!['](https://github.com/iriscafe/devops-test/blob/master/imgs/cicd-workflow.gif?raw=true)

FLuxograma que fiz:
!['](https://github.com/iriscafe/devops-test/blob/master/imgs/cicd-workflow2.png?raw=true)

## Tecnologias Escolhidas e Justificativas:
- Iniciei dockerizando a aplicação e, ao enfrentar dificuldades para expor a API, descobri a necessidade de ajustar um bind para o Gunicorn.
- Utilizei o Terraform para criar toda a infraestrutura inicial, incluindo VPC, EKS, CodePipeline com CodeBuild e ArgoCD. Poderia escolher fazer com cloudformation mas acho mais complexo de usar.
- O CI/CD é realizado pelo CodePipeline junto ao CodeBuild, onde o versionamento de imagem é feito. 
- A imagem criada localmente é enviada para o DockerHub e após o build no coldbuild, é transferida para o ECR para garantir rastreabilidade e versionamento. A tag da imagem no values do Helm Chart é atualizada com o hash do último commit para que o ArgoCD possa implantar a partir da imagem adicionada ao ECR.
- Além disso, foram criados manifestos para implantação de um ambiente de monitoramento usando Grafana e Prometheus, escolhidos por sua facilidade de gerenciamento através dos Helm Charts.

## Melhorias:
- Usar menos hardcode em alguns módulos como ArgoCD e também nos helm charts.
- Implementar o ingress NGINX, por falta do domínio acabei optando por usar LoadBalancar, mas acho que seria muito mais prático o NGINX.
- usar o kustomize pra diferenciar os ambientes e também facilitar o versionamento.
- Uso do cert manager para garantir mais seguranças entre as comunicações.
- Guardar algumas chaves (ssh e toke) usando o secrets da aws por exemplo, acho que tornaria o projeto mais seguro.
- Implementar o cluster Autoscaler para escalabilidade automática do número de nós no cluster, garantindo resposta dinâmica à demanda e economia de recursos, mas devido ao tempo não consegui.
- Implementar toda a infra dividindo entre backend e deployment, onde em backend seria feito a instalação dos recursos e no deployment a execução de toda aplicação sem a necessidade de ajuste manual.

# Histórico de Versões

## [Apr 24, 2024]
- Repositório de origem atualizado no ArgoCD.
- Atualização no CodeBuild e sistema de versionamento.

## [Apr 23, 2024]
- Correção no Dockerfile: inserção de configuração de bind para o Gunicorn.
- Alteração na porta exposta.
- Adição do Helm da aplicação ao ArgoCD.
- Ajuste na configuração do ingress.

## [Apr 22, 2024]
- Correção no Dockerfile.

## [Apr 19, 2024]
- Adição dos arquivos do Helm Charts à aplicação.
- Ajustes no ArgoCD.
- Renomeação do arquivo Codestar e ajuste nas variáveis do CodeBuild.
- Adição do controlador de ingress.
- Adição do Fluxograma.

## [Apr 18, 2024]
- Ajustes nos caminhos do kubectl_manifest para futuros Helm Charts.
- Adição do ArgoCD à implantação.
- Correção do nome do ECR no CodeBuild.
- Atualização da imagem do CodeBuild e do computador.
- Atualização do pip no Dockerfile.
- Atualização do pip na compilação.
- Ajuste no caminho do CodeBuild.
- Adição do CodeBuild à implementação e ao buildspec.
- Ajustes nas permissões do Codestar no CodePipeline.
- Adição do módulo CodePipeline.
- Adição do módulo EKS.
- Adição da VPC.
- Dockerização da aplicação.
- Commit inicial.