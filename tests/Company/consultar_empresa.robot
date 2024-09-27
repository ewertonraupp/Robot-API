*** Settings ***
Resource       ../../resources/company_kws.resource
Suite Setup    Realizar Login Admin


*** Test Cases ***
CT - Consultar empresa por ID
    [Tags]    CONSULTAR_EMPRESA_SUCESSO
    Listar empresas
    Consultar dados empresa