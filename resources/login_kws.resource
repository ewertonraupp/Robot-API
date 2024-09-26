*** Settings ***
Documentation    Arquivo de keywords de login
Resource         package.resource


*** Keywords ***
Criar sessao
    ${HEADERS}      Create Dictionary     Content-Type=Application/json    Authorization=${TOKEN_ADMIN}
    Create Session    auth    url=${AMBIENTE.URL}    headers=${HEADERS}
    
Realizar Login Admin
    ${HEADERS}      Create Dictionary    Content-Type=Application/json
    Create Session    auth    ${AMBIENTE.URL}    ${HEADERS}    disable_warnings=${True}

    ${body}         Create Dictionary    mail=${SYSADMIN.USER}
    ...    password=${SYSADMIN.PASSWORD}

    ${response}     POST On Session    auth    ${AMBIENTE.LOGIN}    json=${body}

    Status Should Be    200
    Dictionary Should Contain Key           ${response.json()}    token
    Set Suite Variable     ${TOKEN_ADMIN}    ${response.json()["token"]}
    Should Not Be Empty    ${TOKEN_ADMIN}
    

