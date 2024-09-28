*** Settings ***
Resource       ../../resources/user_kws.resource
Test Setup     Realizar Login Admin


*** Test Cases ***
Deletar usuário com sucesso
    [Tags]    DELETAR_USUARIO_SUCESSO
    Cadastrar um novo usuário
    Deletar o novo usuário criado