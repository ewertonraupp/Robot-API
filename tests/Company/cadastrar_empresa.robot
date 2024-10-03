*** Settings ***
Documentation    Arquivo contendo os casos de testes de api relacionados a cadastro de empresa
Resource       ../../resources/company_kws.resource
Suite Setup    Realizar Login Admin


*** Test Cases ***
CT - Cadastrar empresa com sucesso
    [Tags]    CADASTRAR_EMPRESA_SUCESSO
    Cadastrar uma nova empresa
    Validar nova empresa criada
    
CT - Consultar empresa por ID
    Consultar empresa

CT - Deletar empresa criada
    Deletar empresa
