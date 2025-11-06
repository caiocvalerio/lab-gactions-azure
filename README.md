# Laboratório: Pipeline CI/CD de API Java para Azure

Este projeto é um laboratório prático que demonstra a criação de um pipeline completo de CI/CD (Integração Contínua e Entrega Contínua) para uma aplicação Java (Spring Boot) usando GitHub Actions, Docker e o Azure Container Registry (ACR).

O objetivo é automatizar o processo desde o *push* do código no GitHub até ter uma imagem Docker segura e pronta para *deploy* num registo de contentores na nuvem.

---

## Tecnologias Utilizadas

* **Java 21:** Linguagem de programação da API.
* **Spring Boot:** Framework para criação da API REST.
* **Maven:** Gestor de dependências e build do projeto.
* **Docker:** Para containerizar a aplicação.
* **GitHub Actions:** Para orquestração do pipeline de CI/CD.
* **Azure Container Registry (ACR):** Registo privado para armazenar as imagens Docker na nuvem.
* **Trivy:** Ferramenta de scan de vulnerabilidades da imagem Docker.

---

## Funcionalidades do Projeto

Este laboratório inclui:

* **API REST Simples:** Um único endpoint `GET /api/v1/hello` que retorna uma saudação.
* **Dockerfile Otimizado:** Um `Dockerfile` multi-stage que utiliza *layers* do Spring Boot para criar uma imagem Docker final mais leve e eficiente.
* **Pipeline de CI/CD Completo:** Um workflow de GitHub Actions que é disparado em *push* ou *pull request* para o ramo `main`.

---

## O Pipeline de CI/CD

O ficheiro `.github/workflows/main.yml` define a automação deste projeto, que é dividida em dois *jobs* principais:

### 1. Job: `build-and-test`

Este *job* é responsável por construir, testar e publicar a imagem Docker.

1.  **Checkout:** Faz o download do código do repositório.
2.  **Setup Java:** Configura o ambiente com Java 21.
3.  **Build com Maven:** Compila o código e gera o ficheiro `.jar` (executando `mvn -U clean package`).
4.  **Run Tests:** Executa os testes unitários (`mvn test`).
5.  **Build docker image:** Constrói a imagem Docker localmente usando o `Dockerfile`.
6.  **Trivy Scan:** Executa um scan de segurança na imagem construída para detetar vulnerabilidades `HIGH` ou `CRITICAL`.
7.  **Azure Login:** Autentica-se no Azure usando as credenciais fornecidas.
8.  **Docker Login to ACR:** Autentica o Docker no Azure Container Registry.
9.  **Tag Docker Image:** Adiciona a tag completa do registry (ex: `meuregistry.azurecr.io/java-api:<sha>`) à imagem local.
10. **Push to Azure CR:** Envia a imagem tagueada para o Azure Container Registry.
11. **Upload Artifact:** Guarda o ficheiro `.jar` como um artefacto do GitHub para ser usado por outros *jobs*.

### 2. Job: `deploy-staging`

Este *job* (que depende do sucesso do `build-and-test`) simula um *deploy* num ambiente de "staging" (homologação).

1.  **Download JAR:** Baixa o artefacto `.jar` guardado pelo *job* anterior.
2.  **Fake Deploy:** Imprime mensagens no log simulando um *deploy* (neste laboratório, não há um *deploy* real configurado).

---

## Configuração e Setup

Para replicar este projeto, é necessário configurar os seguintes **GitHub Repository Secrets**:

* `AZURE_REGISTRY_NAME`: O nome do seu Azure Container Registry (ex: `meuregistry.azurecr.io`).
* `AZURE_CREDENTIALS`: As credenciais JSON de um *Service Principal* (Principal de Serviço) do Azure com permissões para fazer *push* no ACR.
