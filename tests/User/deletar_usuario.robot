*** Settings ***
Resource       ../../resources/user_kws.resource
Test Setup     Realizar Login Admin


*** Test Cases ***
Deletar usuário com sucesso
    [Tags]    DELETAR_USUARIO_SUCESSO
    Gerar um novo usuário
    Cadastrar um novo usuário
    Deletar o novo usuário criado