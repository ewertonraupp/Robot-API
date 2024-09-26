*** Settings ***
Resource       ../../resources/company_kws.resource
Suite Setup    Realizar Login Admin


*** Test Cases ***
CT - Consultar empresa por ID
    Listar empresas
    Consultar dados empresa