*** Settings ***
Documentation    Arquivo de keywords da suíte de usuários
Resource         package.resource


*** Keywords ***
Gerar um novo usuário
    ${CPF}              FakerLibrary.cpf
    ${CPF}              Remove String    ${CPF}    .    -
    ${PRIMEIRO_NAME}    FakerLibrary.First Name
    ${ULTIMO_NAME}      FakerLibrary.Last Name
    ${NOME}    Catenate    ${PRIMEIRO_NAME}    ${ULTIMO_NAME}
    ${MAIL}             FakerLibrary.Email
    
    ${body}         Create Dictionary
    ...    fullName=${NOME}
    ...    mail=${MAIL}
    ...    accessProfile=ADMIN
    ...    cpf=${CPF}
    ...    password=1234@Test
    ...    confirmPassword=1234@Test
    RETURN    &{body}


Cadastrar um novo usuário
    ${body}    Gerar um novo usuário   

    ${HEADERS}       Create Dictionary    Content-Type=Application/json
    ...    Authorization=${TOKEN_ADMIN}
    
    ${response_post_user}    POST On Session    auth    ${AMBIENTE.ENDPOINTS.USER}
    ...    json=${body}    headers=${HEADERS}

    Status Should Be    201
    Dictionary Should Contain Key     ${response_post_user.json()["user"]}    _id
    Dictionary Should Contain Item    ${response_post_user.json()}            msg
    ...    Olá ${body.fullName}, cadastro realizado com sucesso.
    Dictionary Should Contain Item    ${response_post_user.json()["user"]}    mail    ${body.mail}
    Dictionary Should Contain Item    ${response_post_user.json()["user"]}    cpf     ${body.cpf}
    
    Set Test Variable    ${ID}                ${response_post_user.json()["user"]["_id"]}
    Set Test Variable    ${FULLNAME}          ${response_post_user.json()["user"]["fullName"]}
    Set Test Variable    ${CPF}               ${response_post_user.json()["user"]["cpf"]}
    Set Test Variable    ${MAIL}              ${response_post_user.json()["user"]["mail"]}
    Set Test Variable    ${mail_user_edit}    ${response_post_user.json()["user"]["mail"]}

Validar usuário criado
    ${HEADERS}    Criar sessao
    ${response_get_user}    GET On Session    auth    ${AMBIENTE.ENDPOINTS.USER}${ID}
    ...    headers=${HEADERS}

    Status Should Be     200
    Should Be Equal      ${response_get_user.json()["_id"]}         ${ID}
    Should Be Equal      ${response_get_user.json()["mail"]}        ${MAIL}
    Should Be Equal      ${response_get_user.json()["fullName"]}    ${FULLNAME}
    Should Be Equal      ${response_get_user.json()["cpf"]}         ${CPF}


Logar com o novo usuário criado
    ${body}    Create Dictionary    mail=${MAIL}
    ...    password=1234@Test
    
    ${response_login_new_user}    POST On Session    auth    ${AMBIENTE.LOGIN}
    ...    json=${body}

    Set Test Variable    ${TOKEN_USER}     ${response_login_new_user.json()["token"]}


Editar cadastro do novo usuário
    ${HEADERS}    Create Dictionary    Content-Type=Application/json
    ...    Authorization=${TOKEN_USER}

    ${body}    Gerar um novo usuário

    ${response_put_user}    PUT On Session    auth    ${AMBIENTE.ENDPOINTS.USER}${ID}
    ...    json=${body}    headers=${HEADERS}

    Status Should Be    200
    Dictionary Should Contain Item            ${response_put_user.json()}    msg     Dados atualizados com sucesso!
    Set Test Variable    ${ID}                ${response_put_user.json()["updatedUser"]["_id"]}
    Set Test Variable    ${FULLNAME}          ${response_put_user.json()["updatedUser"]["fullName"]}
    Set Test Variable    ${CPF}               ${response_put_user.json()["updatedUser"]["cpf"]}
    Set Test Variable    ${MAIL}              ${response_put_user.json()["updatedUser"]["mail"]}


Validar usuário editado
    ${HEADERS}    Criar sessao
    ${response_get_user}    GET On Session    auth    ${AMBIENTE.ENDPOINTS.USER}${ID}
    ...    headers=${HEADERS}

    Status Should Be     200
    Should Be Equal      ${response_get_user.json()["_id"]}         ${ID}
    Should Be Equal      ${response_get_user.json()["mail"]}        ${MAIL}
    Should Be Equal      ${response_get_user.json()["fullName"]}    ${FULLNAME}
    Should Be Equal      ${response_get_user.json()["cpf"]}         ${CPF}

Consultar usuário
    Criar sessao
    ${response_get_user}    GET On Session    auth    ${AMBIENTE.ENDPOINTS.USER}${ID}

    Dictionary Should Contain Key     ${response_get_user.json()}    _id
    Dictionary Should Contain Item    ${response_get_user.json()}    mail        ${MAIL}
    Dictionary Should Contain Item    ${response_get_user.json()}    fullName    ${FULLNAME}
    Dictionary Should Contain Item    ${response_get_user.json()}    cpf         ${CPF}


Deletar o novo usuário criado
    ${HEADERS}     Criar sessao
    ${response}    DELETE On Session    auth    ${AMBIENTE.ENDPOINTS.USER}${ID}
    ...    headers=${HEADERS}
    
    Should Be Equal As Strings    ${response.json()}[msg]         Usuário deletado com sucesso!.

    ${response}    GET On Session    auth    ${AMBIENTE.ENDPOINTS.USER}${ID}
    ...    headers=${HEADERS}    expected_status=404
    
    Should Be Equal As Strings    ${response.json()}[alert][0]    Esse usuário não existe em nossa base de dados.