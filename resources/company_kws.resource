*** Settings ***
Documentation    Arquivo de keywords da suíte de empresas
Resource         package.resource


*** Keywords ***
Gerar endereco empresa
    ${zipCode}         Generate Random String    length=8     chars=[NUMBERS]
    ${city}            FakerLibrary.city
    ${state}           FakerLibrary.state_abbr
    ${district}        FakerLibrary.neighborhood
    ${street}          FakerLibrary.street_name
    ${number}          Generate Random String    length=3     chars=[NUMBERS]
    ${complement}      Generate Random String    length=6     chars=[NUMBERS]
    ${country}         FakerLibrary.Country
    
    &{endereco}    Create Dictionary
    ...    zipCode=${zipCode}
    ...    city=${city}
    ...    state=${state}
    ...    district=${district}
    ...    street=${street}
    ...    number=${number}
    ...    complement=${complement}
    ...    country=${country}   
    RETURN    &{endereco}

Gerar dados empresa
    ${CNPJ}            Generate Random String  length=14  chars=[NUMBERS]
    ${companyName}     FakerLibrary.Company
    ${companyCNPJ}     Generate Random String    length=14    chars=[NUMBERS]
    ${companyEmail}    FakerLibrary.Company Email
    ${matriz}          FakerLibrary.Company Suffix
    ${phone}           Generate Random String    length=14     chars=[NUMBERS]
    ${service}         FakerLibrary.Job
    ${responsible}     FakerLibrary.First Name
    
    &{dadosEmpresa}    Create Dictionary
    ...    corporateName=${companyName}
    ...    registerCompany=${CNPJ}
    ...    matriz=${matriz}
    ...    responsibleContact=${responsible}
    ...    telephone=${phone}
    ...    mail=${companyEmail}
    ...    serviceDescription=${service}
    RETURN    &{dadosEmpresa}

Gerar empresa
    &{endereco}            Gerar endereco empresa
    @{listaDeEnderecos}    Create List    ${endereco}
    &{empresa}             Gerar dados empresa
    Set To Dictionary      ${empresa}     address=${listaDeEnderecos}
    RETURN                 ${empresa}
    
Cadastrar uma nova empresa
    ${body}    Gerar empresa
    ${HEADERS}       Create Dictionary    Content-Type=Application/json
    ...    Authorization=${TOKEN_ADMIN}
    
    ${response_post_company}    POST On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY}
    ...    json=${body}    headers=${HEADERS}

    Status Should Be    201
    Dictionary Should Contain Key     ${response_post_company.json()["newCompany"]}    _id
    Dictionary Should Contain Item    ${response_post_company.json()}            msg
    ...    Olá a companhia ${body.corporateName} foi cadastrada com sucesso.
    Dictionary Should Contain Item    ${response_post_company.json()["newCompany"]}
    ...    mail    ${body.mail}
    Dictionary Should Contain Item    ${response_post_company.json()["newCompany"]}
    ...    corporateName    ${body.corporateName}
    Dictionary Should Contain Item    ${response_post_company.json()["newCompany"]}
    ...    registerCompany     ${body.registerCompany}

    Set Suite Variable    ${COMPANY_ID}        ${response_post_company.json()["newCompany"]["_id"]}
    Set Test Variable     ${COMPANY_MAIL}      ${response_post_company.json()["newCompany"]["mail"]}
    Set Test Variable     ${CORPORATE_NAME}    ${response_post_company.json()["newCompany"]["corporateName"]}
    Set Test Variable     ${CNPJ}              ${response_post_company.json()["newCompany"]["registerCompany"]}


Validar nova empresa criada
    ${HEADERS}    Criar sessao
    ${response_get_company}    GET On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY}${COMPANY_ID}
    ...    headers=${HEADERS}

    Should Be Equal      ${response_get_company.json()["_id"]}                ${COMPANY_ID}
    Should Be Equal      ${response_get_company.json()["mail"]}               ${COMPANY_MAIL}
    Should Be Equal      ${response_get_company.json()["corporateName"]}      ${CORPORATE_NAME}
    Should Be Equal      ${response_get_company.json()["registerCompany"]}    ${CNPJ}


Listar empresas
    Criar sessao
    ${response}    GET On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY}    expected_status=200


Consultar empresa
    Criar sessao
    ${response_get_company}    GET On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY}${COMPANY_ID}    expected_status=200


Deletar empresa
    ${response_delete_company}    DELETE On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY}${COMPANY_ID}    expected_status=200

    Should Be Equal As Strings    ${response_delete_company.json()}[msg]    Companhia deletado com sucesso.

    ${response_get_company}    GET On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY}${COMPANY_ID}    expected_status=400

    Should Be Equal As Strings    ${response_get_company.json()}[alert][0]    Essa companhia não existe em nosso sistema.


Editar endereco com sucesso
    ${HEADERS}    Create Dictionary    Content-Type=Application/json
    ...    Authorization=${TOKEN_ADMIN}

    ${body}    Gerar empresa

    ${response_put_company}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}
    ...    json=${body}    headers=${HEADERS}

    Status Should Be    201
    Dictionary Should Contain Item    ${response_put_company.json()}    msg     Endereço da companhia atualizado com sucesso.

    Set Suite Variable    ${COMPANY_ID}         ${response_put_company.json()["updateCompany"]["_id"]}
    Set Test Variable     ${COMPANY_ZIPCODE}    ${response_put_company.json()["updateCompany"]["address"][0]["zipCode"]}
    Set Test Variable     ${COMPANY_CITY}       ${response_put_company.json()["updateCompany"]["address"][0]["city"]}
    Set Test Variable     ${COMPANY_COUNTRY}    ${response_put_company.json()["updateCompany"]["address"][0]["country"]}
    

Validar empresa com endereço editado
    ${HEADERS}    Criar sessao
    ${response_get_company}    GET On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY}${COMPANY_ID}
    ...    headers=${HEADERS}

    Status Should Be     200
    Should Be Equal      ${response_get_company.json()["_id"]}                      ${COMPANY_ID}
    Should Be Equal      ${response_get_company.json()["address"][0]["zipCode"]}    ${COMPANY_ZIPCODE}
    Should Be Equal      ${response_get_company.json()["address"][0]["city"]}       ${COMPANY_CITY}
    Should Be Equal      ${response_get_company.json()["address"][0]["country"]}    ${COMPANY_COUNTRY}
    

Campo CEP vazio
    [Arguments]    ${zipCode}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    zipCode=${zipCode}
    Log     ${requestJson}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'CEP' é obrigatório.

Campo CEP excedendo 8 números
    [Arguments]    ${zipCode}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    zipCode=${zipCode}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'CEP' deve conter 8 dígitos

Campo CEP com letras
    [Arguments]    ${zipCode}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    zipCode=${zipCode}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'CEP' só pode conter números

Campo CEP com caracteres especiais
    [Arguments]    ${zipCode}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    zipCode=${zipCode}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'CEP' só pode conter números

Campo cidade vazio
    [Arguments]    ${city}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    city=${city}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'cidade' é obrigatório.

Campo cidade com caracteres especiais
    [Arguments]    ${city}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    city=${city}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'cidade' só pode conter letras e os caracteres especiais 'ª', 'º', '‘' e '-'.

Campo cidade com números
    [Arguments]    ${city}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    city=${city}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'cidade' só pode conter letras e os caracteres especiais 'ª', 'º', '‘' e '-'.

Campo cidade excedendo 50 caracteres
    [Arguments]    ${city}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    city=${city}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'cidade' deve possuir no máximo 50 caracteres.

Campo estado vazio
    [Arguments]    ${state}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    state=${state}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'estado' é obrigatório.

Campo estado com números
    [Arguments]    ${state}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    state=${state}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'estado' só pode conter letras maiúsculas

Campo estado com caracteres especiais
    [Arguments]    ${state}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    state=${state}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'estado' só pode conter letras maiúsculas

Campo estado excedendo 2 caracteres
    [Arguments]    ${state}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    state=${state}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'estado' deve possuir 2 caracteres.

Campo estado com letras minúsculas
    [Arguments]    ${state}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    state=${state}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'estado' só pode conter letras maiúsculas

Campo bairro vazio
    [Arguments]    ${district}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    district=${district}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'bairro' é obrigatório.

Campo bairro excedendo 50 caracteres
    [Arguments]    ${district}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    district=${district}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'bairro' deve possuir no máximo 50 caracteres.

Campo bairro com caracteres especiais
    [Arguments]    ${district}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    district=${district}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'bairro' só pode conter letras, números e os caracteres especiais 'ª', 'º', '‘' e '-'

Campo logradouro vazio
    [Arguments]    ${street}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    street=${street}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'logradouro' é obrigatório.

Campo logradouro com caracteres especiais
    [Arguments]    ${street}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    street=${street}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'logradouro' só pode conter letras, números e os caracteres especiais 'ª', 'º', '‘' e '-'

Campo número vazio
    [Arguments]    ${number}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    number=${number}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'número' é obrigatório.

Campo número excedendo 10 caracteres
    [Arguments]    ${number}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    number=${number}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'número' deve possuir no máximo 10 caracteres.

Campo complemento excedendo 80 caracteres
    [Arguments]    ${complement}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    complement=${complement}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'complemento' deve possuir no máximo 80 caracteres.

Campo complemento com caracteres especiais
    [Arguments]    ${complement}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    complement=${complement}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo 'complemento' só pode conter letras, números e os caracteres especiais 'ª', 'º', '‘' e '-'

Campo país vazio
    [Arguments]    ${country}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    country=${country}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400

    Should Be Equal As Strings    ${response.json()}[error][0]    O campo País é obrigatório.

Campo país excedendo 50 caracteres
    [Arguments]    ${country}
    ${requestJson}    Gerar empresa
    Set To Dictionary    ${requestJson}[address][0]    country=${country}
    ${response}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.COMPANY_ADDRESS}${COMPANY_ID}    json=${requestJson}    expected_status=400
    
    Should Be Equal As Strings    ${response.json()}[error][0]    O campo País permite até 50 caracteres.
