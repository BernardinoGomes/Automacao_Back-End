*** Settings ***
Resource     desafioapi.resource

*** Test Cases ***
Test Case 01 - Validar conexão do WebService da ViaCEP
        [Documentation]    Validar conexão ao WebService da ViaCEP
        [Tags]             conexão
        Conectar WebService da ViaCEP

Test Case 02 - Consultar Cep válido
          [Documentation]    Validar uma consulta ao WebService da ViaCEP para CEP válido.
          [Tags]             cep_válido
          Consultar CEP "04730080"

Test Case 03 - Consultar Cep válido e validar se o retorno do json estão corretos
          [Documentation]    Validar uma consulta ao WebService da ViaCEP para CEP válido e validar os campo
          ...                logradouro, bairro e localidade
          [Tags]             cep_válido 
          Consultar CEP "04730080"
          Validar logradouro "Rua Acari"
          Validar bairro "Várzea de Baixo"
          Validar localidade "São Paulo"

Test Case 04 - Consultar Cep inválido e validar o retorno de erro
        [Documentation]    Validação API retorna status 400 para um CEP com dígitos menores que 8
        Verificar resposta para "1234" com menos de 8 dígitos

Test Case 05 - Consultar Cep inválido e validar o retorno de erro
        [Documentation]    Validação API retorna status 400 para um CEP com dígitos maiores que 8
        Verificar resposta para "123456789" com mais de 8 dígitos

Test Case 06 - Consultar Cep com caracteres não numéricos e validar o retorno de erro
        [Documentation]    Validação API retorna status 400 para um CEP com caracteres não numérico
        Validar entradas que contêm "ABCD1234" com caracteres não numéricos e verificar se são tratadas corretamente

Test Case 07 - Consultar Cep inexistente e validar o código de retorno
        [Documentation]    Validação API retorna status 200 para um CEP inexistente
        Validar entrada que contêm um cep "99999999" inexistente