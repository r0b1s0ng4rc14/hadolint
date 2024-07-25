# Pequenas ações para melhorar suas imagens

Exemplos simples, de como se beneficiar através de boas práticas na criação de imagens a serem utilizadas em microserviços.

### Apresentando a ferramenta Hadolint.

Repositório oficial: [hadholint](https://github.com/hadolint/hadolint)

Como a instalação é bem simples, não vou documentar essa parte. Acessando o repositório, você encontrará todos os passos para instalação nos sistemas operacionais (Linux, Mac e Windows).

Vamos lá, a ideia é ser rápido e prático.
No diretório de exemplo, criei um Dockerfile não seguindo as boas práticas.
A seguir, será descrito o que é e como desenvolvi através da ferramenta HADOLINT.


#### Exemplo

No diretório Exemplo, temos a seguinte estrutura:

```Bash
.
├── Dockerfile
└── src
    ├── main.py
    └── requirements.tx
```

Temos um script simples que faz o consumo da API Chuck Norris, a qual retorna um texto cômico.

Focando no Dockerfile, ele foi criado propositalmente com algumas más práticas a nível de estudo.
```Dockerfile
FROM python

WORKDIR /app
COPY ./src/* /app

RUN apt-get update
RUN pip install -r requirements.txt

CMD python3 main.py
``` 

Vamos rodar o hadolint e ver quais sugestões ele nos retorna.
```bash
root@zeroday:/# hadolint Dockerfile
Dockerfile:1 DL3006 warning: Always tag the version of an image explicitly
Dockerfile:6 DL3009 info: Delete the apt-get lists after installing something
Dockerfile:7 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.
Dockerfile:7 DL3042 warning: Avoid use of cache directory with pip. Use `pip install --no-cache-dir <package>`
Dockerfile:9 DL3025 warning: Use arguments JSON notation for CMD and ENTRYPOINT arguments
```

Para pesquisar qual é o problema, basta acessar o próprio repositório do Hadolint, copiar o código (por exemplo, DL3006) e acessar o link para entender o que precisamos fazer.

Vamos corrigir.

- [DL3006](https://github.com/hadolint/hadolint/wiki/DL3006) Correção da versão da imagem.
- [DL3009](https://github.com/hadolint/hadolint/wiki/DL3009) Limpeza de cache apt.
- [DL3059](https://github.com/hadolint/hadolint/wiki/DL3059) A cada RUN executado, gera-se uma nova camada, limitando a exclusão de arquivos temporários.
- [DL3042](https://github.com/hadolint/hadolint/wiki/DL3042) Limpeza de cache pip.
- [DL3025](https://github.com/hadolint/hadolint/wiki/DL3025) Explicação entre CMD e Entrypoint correção escrita.

#### Correções 

```Dockerfile
FROM python:3.9.19

WORKDIR /app
COPY ./src/* /app

RUN apt-get update \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
&& pip install --no-cache-dir -r requirements.txt

CMD [ "python3","main.py" ] 
```

Rodando a ferramenta
```Bash
root@zeroday:/# hadolint Dockerfile
root@zeroday:/#
```

Tudo certo.

#### Execução local

Caso queira testar a execução do container no seu Docker local, execute o build.

- Build 
```bash
docker build -t chucknorris-hadolint:v1 .
```
>O docker build deve ser executado no diretório onde o Dockerfile se encontra.
- Run
```bash
docker run -it --rm chucknorris-hadolint:v1
```
>Esse comando executa o container em modo interativo e, após terminar, o remove.

Simples e fácil.
