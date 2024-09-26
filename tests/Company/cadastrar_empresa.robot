*** Settings ***
Resource       ../../resources/company_kws.resource
Suite Setup    Realizar Login Admin


*** Test Cases ***
CT - Cadastrar empresa com sucesso
    Gerar empresa
    Cadastrar uma nova empresa
    Conferir se a nova empresa foi cadastrada corretamente

CT - Consultar empresa por ID
    Consultar dados empresa

CT - Editar endereço empresa
    Editar endereco    11111111

CT - Deletar empresa criada
    Deletar empresa
