*** Settings ***
Resource       ../../resources/user_kws.resource
Test Setup     Realizar Login Admin


*** Test Cases ***
Consultar usuário por ID
    [Tags]    CONSULTAR_USUARIO
    Gerar um novo usuário
    Cadastrar um novo usuário
    Consultar usuário
    Deletar o novo usuário criado