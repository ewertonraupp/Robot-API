*** Settings ***
Resource       ../../resources/company_kws.resource
Suite Setup    Realizar Login Admin


*** Test Cases ***
CT - Consultar empresa por ID
    [Tags]    CONSULTAR_EMPRESA_SUCESSO
    Cadastrar uma nova empresa
    Validar nova empresa criada
    Listar empresas
    Consultar empresa
    Deletar empresa