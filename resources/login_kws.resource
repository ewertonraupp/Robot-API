*** Settings ***
Documentation    Arquivo de keywords de login
Resource         package.resource


*** Keywords ***
Criar sessao
    ${HEADERS}      Create Dictionary     Content-Type=Application/json    Authorization=${TOKEN_ADMIN}
    Create Session    auth    url=${AMBIENTE.URL}    headers=${HEADERS}
    

Realizar Login Admin
    ${HEADERS}      Create Dictionary    Content-Type=Application/json
    Create Session    auth    url=${AMBIENTE.URL}    headers=${HEADERS}    disable_warnings=${True}

    ${body}         Create Dictionary    mail=${SYSADMIN.USER}
    ...    password=${SYSADMIN.PASSWORD}

    ${response}     POST On Session    auth    ${AMBIENTE.LOGIN}    json=${body}

    Status Should Be    200
    Dictionary Should Contain Key                ${response.json()}    token
    Set Suite Variable      ${TOKEN_ADMIN}       ${response.json()["token"]}
    Should Not Be Empty     ${TOKEN_ADMIN}
    Set Suite Variable      ${fullname_user}     ${response.json()["user"]["fullName"]}
    Set Suite Variable      ${response_login}    ${response.json()}


Validar Login com sucesso
    Log    ${response_login}
    Status Should Be    200
    Dictionary Should Contain Key    ${response_login}    msg
    Dictionary Should Contain Key    ${response_login}    token
    Should Be Equal    ${response_login["msg"]}      Olá ${fullname_user}, autenticação autorizada com sucesso!
    Should Be Equal    ${response_login["token"]}    ${TOKEN_ADMIN}




