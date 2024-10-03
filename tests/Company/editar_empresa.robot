*** Settings ***
Documentation    Arquivo contendo os casos de testes de api relacionados a editar cadastro de empresa
Resource       ../../resources/company_kws.resource
Suite Setup    Realizar Login Admin


*** Test Cases ***
CT - Cadastrar empresa com sucesso
    Cadastrar uma nova empresa
    Validar nova empresa criada

CT - Editar endereço empresa
    Editar endereco com sucesso
    Validar empresa com endereço editado

    Campo CEP vazio    ${EMPTY}
    Campo CEP excedendo 8 números    123456789
    Campo CEP com letras    SPSPSPSP
    Campo CEP com caracteres especiais    --------

    Campo cidade vazio    ${EMPTY}
    Campo cidade com caracteres especiais    São Paulo@#$%&%&*
    Campo cidade com números    São Paulo 123
    Campo cidade excedendo 50 caracteres    São Paulo@$#*!-123 São Paulo@$#*!-123 São Paulo@&*!

    Campo estado vazio    ${EMPTY}
    Campo estado com números    22
    Campo estado com caracteres especiais    --
    Campo estado excedendo 2 caracteres    SPPPP
    Campo estado com letras minúsculas    sp

    Campo bairro vazio    ${EMPTY}
    Campo bairro excedendo 50 caracteres    123fds4567890dsfs1234789012fd123fds4567890dsfs12347
    Campo bairro com caracteres especiais    @#$%&* @#$%&* @#$%&*

    Campo logradouro vazio    ${EMPTY}
    Campo logradouro com caracteres especiais    123fds45@#$90 dsfs12*&#$8901 123fds45@#$90 dsfs12*&#$8901 123fds45@#$90 dsfs12*&

    Campo número vazio    ${EMPTY}
    Campo número excedendo 10 caracteres    12345678910

    Campo complemento excedendo 80 caracteres    de 4503 ao fim - lado ímpar de 4503 ao fim - lado ímpar de 4503 ao fim - ladossss
    Campo complemento com caracteres especiais    @#$%&* @#$%&* @#$%&*

    Campo país vazio    ${EMPTY}
    Campo país excedendo 50 caracteres    Braaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaasilllllll

CT - Deletar empresa criada
    Deletar empresa
