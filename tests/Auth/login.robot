*** Settings ***
Resource       ../../resources/login_kws.resource

*** Test Cases ***
Login admin com sucesso
    Realizar Login Admin
    Validar Login com sucesso
