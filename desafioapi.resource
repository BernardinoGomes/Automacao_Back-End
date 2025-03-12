*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
${URL}    https://viacep.com.br/ws/

*** Keywords ***
Conectar WebService da ViaCEP
        [Documentation]    Estabelece uma conexão com o WebService da ViaCEP para consultas de CEP.
        Create Session        ViaCep        ${URL}        #disable_warnings=True

Consultar CEP "${cep_numero}"
        [Documentation]    Realiza uma consulta ao WebService da ViaCEP para obter informações de um CEP específico.
        ...                Realiza requisição GET ao endpoint e armazena a resposta da requisição na variável de suíte ${response}.
        ${response}=        GET On Session       ViaCep        /ws/${cep_numero}/json
        Set Suite Variable  ${response}

Validar logradouro "${logradouro}"
        [Documentation]    Valida o logradouro retornado pela API ViaCEP contra um valor esperado.
    ...                    Falha se os valores não forem iguais.
        Should Be Equal As Strings    ${logradouro}    ${response.json()}[logradouro]


Validar bairro "${bairro}"
        [Documentation]    Valida o bairro retornado pela API ViaCEP contra um valor esperado.
    ...                    Falha se os valores não forem iguais.
        Should Be Equal As Strings    ${bairro}    ${response.json()}[bairro]

Validar localidade "${localidade}"
        [Documentation]    Valida o localidade retornado pela API ViaCEP contra um valor esperado.
    ...                    Falha se os valores não forem iguais.
        Should Be Equal As Strings    ${localidade}    ${response.json()}[localidade]

Validar entradas que contêm "${cep_numero}" com caracteres não numéricos e verificar se são tratadas corretamente
    [Documentation]    Valida se a API retorna status 400 para um CEP com formato inválido.
    ${cep_numero} =    Set Variable    ${cep_numero}
    ${response}=    GET    ${URL}${cep_numero}/json/    expected_status=any
    Should Be Equal As Numbers    ${response.status_code}    400

Verificar resposta para "${cep_numero}" com menos de 8 dígitos
    [Documentation]    Valida se a API retorna status 400 para um CEP com menos de 8 dígitos.
    ${cep_numero}=    Set Variable    ${cep_numero}
    ${response}=    GET    ${URL}${cep_numero}/json/    expected_status=any
    Should Be Equal As Numbers    ${response.status_code}    400

Verificar resposta para "${cep_numero}" com mais de 8 dígitos
     [Documentation]    Valida se a API retorna status 400 para um CEP com menos de 8 dígitos
    ${cep_numero}=    Set Variable    ${cep_numero}
    ${response}=    GET    ${URL}${cep_numero}/json/    expected_status=any
    Should Be Equal As Numbers    ${response.status_code}    400

Validar entrada que contêm um cep "${cep_numero}" inexistente
    [Documentation]    Valida o retorno da API com  status true para um CEP inexistente
    ${cep_numero}=    Set Variable    ${cep_numero}
    ${response}=    GET    ${URL}${cep_numero}/json/    expected_status=any
    Should Be Equal As Numbers    ${response.status_code}    200
