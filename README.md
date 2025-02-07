# Speakers-App

Este projeto foi desenvolvido na Turma 13 do Treina Dev da Campus Code.

É um sistema integrado de três aplicações para gerenciar conteúdos e tarefas de eventos e seus participantes.

## Tecnologias

[![Ruby][Ruby-badge]][Ruby-url]
[![RubyOnRails][RubyOnRails-badge]][RubyOnRails-url]
[![TailwindCSS][Tailwind-badge]][Tailwind-url]

## Gems utilizadas

- [rubocop-rails-omakase](https://github.com/rubocop/rubocop-rails) - Um conjunto de regras para manter o código Rails limpo e consistente.
- [rspec-rails](https://github.com/rspec/rspec-rails) - Framework de testes para aplicações Rails.
- [capybara](https://github.com/teamcapybara/capybara) - Ferramenta de teste de integração para simular a interação do usuário com a aplicação.
- [cuprite](https://github.com/rubycdp/cuprite) - Driver de teste para Capybara usando o Chrome DevTools Protocol.
- [simplecov](https://github.com/simplecov-ruby/simplecov) - Gera relatórios de cobertura de código.
- [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails) - Biblioteca para criar dados de teste de forma fácil e limpa.
- [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) - Fornece matchers para testes RSpec que simplificam a escrita de testes.
- [faker](https://github.com/faker-ruby/faker) - Gera dados fictícios para testes.
- [devise](https://github.com/heartcombo/devise) - Solução de autenticação flexível para Rails.
- [faraday](https://github.com/lostisland/faraday) - Biblioteca HTTP para fazer requisições.
- [sqlite3](https://github.com/sparklemotion/sqlite3-ruby) - Interface para o banco de dados SQLite3.
- [turbo-rails](https://github.com/hotwired/turbo-rails) - Ferramentas para criar aplicações Rails mais rápidas dinâmicas.
- [stimulus-rails](https://github.com/hotwired/stimulus-rails) - Framework JavaScript para adicionar interatividade a aplicações Rails.
- [tailwindcss-rails](https://github.com/rails/tailwindcss-rails) - Integração do Tailwind CSS com Rails.

## Configuração

Acesse [TreinaDev/speakers-app](https://github.com/TreinaDev/speakers-app) e execute os seguintes comandos:

```sh
git clone git@github.com:TreinaDev/speakers-app.git
cd speakers-app
bin/setup
```

Se necessário utilize o seguinte comando para colocar a aplicação no ar:

```sh
bin/dev
```

## Testes

Para rodar os testes, execute:

```sh
rspec
```
## API
Documentação da API
### 1 - Currículo
#### GET /api/v1/curriculums/:schedule_item_code
Exibe as tarefas e conteúdos de um currículo, que representa todos os dados para uma programação.

* status: 200
* content-type: application/json

```
{
  "curriculum": {
    "curriculum_contents": [
      {
        "last_update": "07/02/2025"
        "code": "MH0IBQ8O",
        "title": "Ruby PDF",
        "description": "\u003Cstrong\u003EDescrição Ruby PDF\u003C/strong\u003E",
        "external_video_url": "\u003Ciframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/idaXF2Er4TU' frameborder='0' allowfullscreen\u003E\u003C/iframe\u003E",
        "files": [
          {
            "filename": "puts.png",
            "file_download_url": "http://127.0.0.1:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--97207adb5d87fac1fb977c3ae5b3896f2de5fe1a/puts.png"
          }
        ]
      }
    ],
    "tasks_available": true
    "curriculum_tasks": [
      {
        "code": "FNRVUEUB",
        "title": "Exercício Rails",
        "description": "Seu primeiro exercício ruby",
        "certificate_requirement": "Obrigatória",
        "attached_contents": [
          {
            "attached_content_code": "MH0IBQ8O"
          }
        ]
      }
    ]
  }
}
```

* status: 404
* content-type: application/json

```
{
  "error": "Currículo não encontrado!"
}
```

* curriculum_contents: Conteúdos;
  - code: Código de identificação;
  - last_update: Última atualização;
  - title: Título;
  - description: Descrição com texto enriquecido;
  - external_video_url: Link de um video externo dentro de um iframe para exibição;
* files: Arquivos;
  - filename: Nome do arquivo;
  - file_download_url: URL do arquivo;
* curriculum_tasks: Tarefas;
  - code: Código de identificação;
  - title: Título;
  - description: Descrição;
  - certificate_requirement: Tarefa obrigatória ou opcional;
* attached_contents: Conteúdos anexados a tarefa;
  - attached_content_code: Código de referencia de um conteúdo;
* tasks_available: Disponibilidade das tarefas;
  
## Contribuidores

[<img src="https://avatars.githubusercontent.com/u/162291567" width=115 > <br> <sub> Bruno Herculano </sub>](https://github.com/Bruno-H-Terto)|[<img src="https://avatars.githubusercontent.com/u/126020568?v=4" width=115 > <br> <sub> Pedro Dias </sub>](https://github.com/PedroD98)|[<img src="https://avatars.githubusercontent.com/u/83383321?v=4" width=115 > <br> <sub> Matheus Santana </sub>](https://github.com/matheusfsantana)|[<img src="https://avatars.githubusercontent.com/u/104660897?v=4" width=115 > <br> <sub> Thiago Gois </sub>](https://github.com/ThiagoGois1011)|[<img src="https://avatars.githubusercontent.com/u/144969255?v=4" width=115 > <br> <sub> Lucas Caetano </sub>](https://github.com/caetano-lucas)| 
| :---: | :---: | :---: | :---: | :---: |

<!-- MARKDOWN LINKS & IMAGES -->
[Ruby-badge]: https://img.shields.io/static/v1?label=Ruby&message=3.2.2&color=red&style=for-the-badge&logo=ruby
[Ruby-url]: https://www.ruby-lang.org/en/news/2023/03/30/ruby-3-2-2-released/
[RubyOnRails-badge]: https://img.shields.io/static/v1?label=Ruby%20On%20Rails&message=8.0.1&color=red&style=for-the-badge&logo=rubyonrails
[RubyOnRails-url]: https://rubyonrails.org/2023/11/10/Rails-7-1-2-has-been-released
[Tailwind-badge]: https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white
[Tailwind-url]: https://tailwindcss.com/
