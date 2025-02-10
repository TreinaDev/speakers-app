# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.new(first_name: 'João', last_name: 'Campus', email: 'marcos@email.com', password: '123456', token: 'ABCD1234')
joao = User.new(first_name: 'João', last_name: 'Campus', email: 'speaker0@email.com', password: '123456', token: 'ASDF4567')
matheus = User.new(first_name: 'Matheus', last_name: 'Santana', email: 'matheus@email.com', password: '123456', token: 'IMPOSTOR')
user.save(validate: false)
joao.save(validate: false)
matheus.save(validate: false)
FactoryBot.create(:profile, user: matheus)
curriculum_matheus = FactoryBot.create(:curriculum, user: matheus, schedule_item_code: 'IMPOSTOR')
matheus_content = matheus.event_contents.create(title: 'Ruby PDF', description: '<strong>Descrição Ruby PDF</strong>',
                                                 external_video_url: 'https://www.youtube.com/watch?v=idaXF2Er4TU', files: [ { io: File.open(Rails.root.join('spec/fixtures/puts.png')),
                                                filename: 'puts.png', content_type: 'image/png' } ])

matheus.event_contents.create(title: 'Introdução a Ruby', description: 'Descrição Ruby', external_video_url: 'https://www.youtube.com/watch?v=bLDH3NypOVo')
matheus.event_contents.create(title: 'Introdução a TDD com Ruby', description: 'Descrição Ruby', external_video_url: 'https://www.youtube.com/watch?v=awn-Z_0lle0')
matheus.event_contents.create(title: 'Variaveis de ambiente em Ruby', description: 'Descrição Ruby', external_video_url: 'https://www.youtube.com/watch?v=iXKuv-Y4c_Q')

matheus_curriculum_content = FactoryBot.create(:curriculum_content, curriculum: curriculum_matheus, event_content: matheus_content)
matheus_task = FactoryBot.create(:curriculum_task, curriculum: curriculum_matheus, title: 'Exercício Rails', description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory)
FactoryBot.create(:curriculum_task_content, curriculum_task: matheus_task, curriculum_content: matheus_curriculum_content)
FactoryBot.create(:certificate, responsable_name: matheus.full_name, speaker_code: 'IMPOSTOR', schedule_item_name: 'Workshop - Arquitetura Serverless na AWS',
                  schedule_item_code: 'IMPOSTOR', participant_code: 'MASTER123', token: 'ACBD1234ABCD1234ABCD', event_name: 'AWS re:Invent')

curriculum = FactoryBot.create(:curriculum, user: user, schedule_item_code: 'ABCDEEGH')
first_content = user.event_contents.create(title: 'Ruby PDF', description: '<strong>Descrição Ruby PDF</strong>', code: 'ABCD1234',
                                                 external_video_url: 'https://www.youtube.com/watch?v=idaXF2Er4TU', files: [ { io: File.open(Rails.root.join('spec/fixtures/puts.png')),
                                                filename: 'puts.png', content_type: 'image/png' } ])
first_curriculum_content = FactoryBot.create(:curriculum_content, curriculum: curriculum, event_content: first_content)
first_task = FactoryBot.create(:curriculum_task, curriculum: curriculum, title: 'Exercício Rails', description: 'Seu primeiro exercício ruby', certificate_requirement: :mandatory)
FactoryBot.create(:curriculum_task_content, curriculum_task: first_task, curriculum_content: first_curriculum_content)

profile = Profile.create!(title: 'Instrutor / Desenvolvedor',
                          about_me: 'Sou João, desenvolvedor Ruby apaixonado por criar soluções eficientes e bem estruturadas.
                          Meu principal foco está no Ruby on Rails, onde tenho ampla experiência no desenvolvimento de aplicações
                          web modernas e escaláveis. Gosto de transformar ideias em realidade por meio de código limpo, organizado e
                          que prioriza a manutenibilidade.
                          Tenho um grande interesse por boas práticas de desenvolvimento, como TDD, padrões de design e princípios
                          de desenvolvimento ágil. Além de programar, busco estar sempre atualizado com as tendências do mercado e
                          as novas tecnologias que podem agregar valor aos projetos em que trabalho.
                          Minha motivação vem da possibilidade de resolver problemas reais, criando sistemas que otimizem processos,
                          melhorem a experiência dos usuários e tragam impacto positivo para as empresas. Fora do mundo do código, gosto
                            de compartilhar conhecimento, aprender com a comunidade e me desafiar constantemente a ser um profissional melhor.',
                          user: user, profile_picture: { io: File.open(Rails.root.join('spec/fixtures/puts.png')), filename: 'puts.png',
                          content_type: 'image/png' }, gender: 'Masculino', pronoun: 'Ele/Dele', city: 'Salvador', birth: '1999-01-25')
profile.social_networks.create(url: 'https://www.joaotutoriais.com/', social_network_type: :my_site)
profile.social_networks.create(url: 'https://www.youtube.com/@JoãoTutoriais', social_network_type: :youtube)
profile.social_networks.create(url: 'https://x.com/joao', social_network_type: :x)
profile.social_networks.create(url: 'https://github.com/joaorsalmeida', social_network_type: :github)
profile.social_networks.create(url: 'https://www.facebook.com/joaoalmeida', social_network_type: :facebook)

content = user.event_contents.create!(title: 'Ruby para iniciantes',
                                      description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.
                                      Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an
                                       unknown printer took a galley of type and scrambled it to make a type specimen book.
                                        It has survived not only five centuries, but also the leap into electronic typesetting,
                                         remaining essentially unchanged. It was popularised in the 1960s with the release of
                                          Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing
                                           software like Aldus PageMaker including versions of Lorem Ipsum.')

content.files.attach(
  io: File.open(Rails.root.join('spec/fixtures/nota-ufjf.pdf')),
  filename: 'nota-ufjf.pdf',
  content_type: 'application/pdf'
)

content.files.attach(
  io: File.open(Rails.root.join('spec/fixtures/mark_zuckerberg.jpeg')),
  filename: 'mark_zuckerberg.jpeg',
  content_type: 'image/jpeg'
)

content.files.attach(
  io: File.open(Rails.root.join('spec/fixtures/capi.png')),
  filename: 'capi.png',
  content_type: 'image/png'
)

content.files.attach(
  io: File.open(Rails.root.join('spec/fixtures/puts.png')),
  filename: 'puts.png',
  content_type: 'image/png'
)

content.files.attach(
  io: File.open(Rails.root.join('spec/fixtures/joker.mp4')),
  filename: 'joker.mp4',
  content_type: 'video/mp4'
)
