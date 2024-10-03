*** Settings ***
Documentation    Arquivo contendo os casos de testes de api relacionados a editar cadastro de usuário
Resource       ../../resources/user_kws.resource
Test Setup     Realizar Login Admin


*** Test Cases ***
Editar cadastro de usuário
    [Tags]    EDITAR_USUARIO_SUCESSO
    Cadastrar um novo usuário
    Validar usuário criado
    Logar com o novo usuário criado
    Editar cadastro do novo usuário
    Validar usuário editado
    Deletar o novo usuário criado