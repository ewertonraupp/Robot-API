*** Settings ***
Resource       ../../resources/company_kws.resource
Suite Setup    Realizar Login Admin


*** Test Cases ***
CT - Deletar empresa criada
    [Tags]    DELETAR_EMPRESA_SUCESSO
    Cadastrar uma nova empresa
    Validar nova empresa criada
    Deletar empresa

# Pré Requisito
# Ação 
# Resultado esperado e validação