<p align="center">
  <img src="https://static.wixstatic.com/media/676771_ff90eb66aa924b0b88cdd4df171f3d85~mv2.png/v1/fill/w_774,h_342,al_c,lg_1,q_85/676771_ff90eb66aa924b0b88cdd4df171f3d85~mv2.png">
</p>


![STATUS](https://img.shields.io/static/v1?label=STATUS&message=%20FINALIZADO&color=GREEN&style=for-the-badge)


## 💬 Robot Framework - Qa. Coders ##
Este repositório contém um conjunto de testes automatizados utilizando o Robot Framework. O objetivo é demonstrar como configurar e executar testes automatizados para uma API ou uma aplicação WEB.


## 👨‍💻 Testes API Back-End ##
Este projeto tem como objetivo realizar testes de API utilizando o Robot Framework no ambiente Qa.Coders.


## 💻 Requisitos ##
Antes de começar, certifique-se de ter os seguintes itens instalados:

- [Python](https://www.python.org/downloads/) (versão 3.9 ou superior)
- [Robot Framework](https://robotframework.org/) (versão mais recente)
- [Robot Framework-Faker](https://pypi.org/project/robotframework-faker/) (versão mais recente)
- [Robot PyYAML](https://pypi.org/project/PyYAML/) (versão mais recente)
- [RequestsLibrary](https://github.com/robotframework/RequestsLibrary) para testes de API


## ✔️ Instruções para a execução ##
Execute os testes usando o comando a seguir, substituindo nome_arquivo.robot pelo nome do arquivo que contém os seus casos de teste.
```bash
robot -d ./logs tests/nome_arquivo.robot
```


## 📚 Descrição dos Diretórios e Arquivos
- **tests/**: Contém arquivos de teste escritos em Robot Framework. Cada arquivo pode conter um ou mais casos de teste.

- **resources/**: Contém recursos adicionais que podem ser utilizados pelos testes, como:
  - **company_kws.resource/**: Arquivo de Keywords da suíte de empresa.
  - **login_kws.resource/**: Arquivo de Keywords da suíte de login.
  - **usuarios_kws.resource/**: Arquivo de Keywords da suíte de usuário.
  - **package.resource/**: Onde são gerenciadas as dependencias da automação.

- **fixtures/**: Contém recursos adicionais que podem ser utilizados pelos testes, como:
  - **data.yaml/**: Arquivo contendo as variaveis de usuarios e senhas.
  - **environments.yaml/**: Arquivo contendoas variaveis dos endereços dos ambientes.

- **logs/**: Local onde os relatórios gerados após a execução dos testes são armazenados.

- **README.md**: Documento com informações sobre o projeto, como configuração, execução de testes, etc.


## 📁 Dependencias ##
```
├── .github/workflows
│   ├── robot-framework.yml
│   
├── fixtures
│   ├── data.yaml
│   ├── environments.yaml
│
├── logs
│   ├── log.html
│   ├── output.xml
│   ├── report.html
│   
├── resources
|   ├── package.resource
|   ├── cadastro_usuario_kws.resource
|   ├── cadastro_empresa_kws.resource
|   ├── login_kws.resource
| 
├── tests
│   ├── login.robot
│   ├── cadastrar_empresa.robot
│   ├── consultar_empresa.robot
│   ├── deletar_empresa.robot
│   ├── editar_empresa.robot
│   ├── cadastrar_usuario.robot
│   ├── consultar_empresa.robot
│   ├── deletar_usuario.robot
│   ├── editar_usuario.robot
│   
├──.gitignore
├── README.md
```