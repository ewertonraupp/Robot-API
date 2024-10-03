*** Settings ***
Documentation    Arquivo contendo os casos de testes de api relacionados a consulta de usuário
Resource       ../../resources/user_kws.resource
Test Setup     Realizar Login Admin


*** Test Cases ***
Consultar usuário por ID
    [Tags]    CONSULTAR_USUARIO_SUCESSO
    Cadastrar um novo usuário
    Consultar usuário
    Deletar o novo usuário criado