*** Settings ***
Resource       ../../resources/user_kws.resource
Test Setup     Realizar Login Admin


*** Test Cases ***
Cadastro de usuário com sucesso
    [Tags]    CADASTRAR_USUARIO_SUCESSO
    Cadastrar um novo usuário
    Validar usuário criado
    Deletar o novo usuário criado