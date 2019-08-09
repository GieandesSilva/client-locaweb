## CLIENTE LOCAWEB

O que você encontra aqui:
    
    * web-base   - Um serviço com ALPINE + NGINX
    * app-base   - Um serviço com ALPINE + VueJs

## Instalação

* Faça o clone do projeto:

```bash
    git clone https://github.com/GieandesSilva/client-locaweb.git [nome-do-projeto]
```

* Entre na pasta [nome-do-projeto] e rode:

```bash
    docker-compose up -d
```

* Verifique se os containers estão de pé [opcional]:

```bash
    docker ps
```

* Acesse o container do aplicativo para instalar as dependências:

```bash
    docker exec -ti client-base sh
```
    
* Dentro do container execute os comandos:
    
```bash
    * Instale as dependências com npm:
    
        npm install

    * Faça uma cópia do .env.example:

        cp .env.example .env

    * Altere as permissões do .env:
    
        chgrp node .env && chown node .env

    * No env, altere as variáveis com os valores recebidos da authenticação da api

        Exemplo: 
        VUE_APP_API_CLIENT_ID="2"
        VUE_APP_API_CLIENT_SECRET= "tHrtmPttcx1iTJV1XxQTnJbLQLvRdqkLaVlqwjDA"

    * Gere o build do projeto com o comando:
    
        npm run build

```

* Verifique o seu projeto rodando no link:

```bash
    http://localhost:8080/
```
            
## :D
Obrigado por acompanhar os passos e espero ter ajudado.

## Nós
[Gieandes Silva](http://gieandessilva.com)
