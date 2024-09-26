*** Settings ***
Resource       ../../resources/company_kws.resource
Suite Setup    Realizar Login Admin


*** Test Cases ***
CT - Deletar empresa criada
    Listar empresas
    Deletar empresa

# Pré Requisito
# Ação 
# Resultado esperado e validação