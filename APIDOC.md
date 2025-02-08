## API
Documentação da API
### 1 - Currículo
#### GET /api/v1/curriculums/:schedule_item_code
Exibe as tarefas e conteúdos de um currículo, que representa todos os dados para uma programação.
Com o campo 'task_status', é possível verificar se a tarefa específica foi concluída por um participante.

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
        "task_status": false
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
  

### 2 - Palestrante
#### GET /api/v1/speakers/:email
Exibe informações relacionadas a um Palestrante, como perfil e foto.
##### Success
```
{
  "speaker": {
    "first_name": "João",
    "last_name": "Campus",
    "role": "Instrutor / Desenvolvedor",
    "profile_image_url": "http://localhost:3001/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MiwicHVyIjoiYmxvYl9pZCJ9fQ==--ebfdd59e5d6e192489027db8432b8b2b77b0c8ae/puts.png",
    "profile_url": "http://localhost:3001/profiles/joao_campus"
  }
}
```
* speaker
  - first_name: Primeiro nome
  - last_name: Sobrenome
  - role: Cargo/Título
  - profile_image_url: rota para exibição da imagem de perfil
  - profile_url: rota para acesso ao perfil público do Palestrante

##### Not Found
* status: 404
* content-type: application/json

```
{
  "error": "Palestrante não encontrado!"
}
```

#### Internal Server Error

* status: 500
* content-type: application/json

```
{
  "error": "Algo deu errado."
}
```