*** Settings ***
Documentation    Arquivo que contem todas as variaveis da page de login
Resource       ../../resources/login_kws.resource

*** Test Cases ***
Login admin com sucesso
    Realizar Login Admin
    Validar Login com sucesso
