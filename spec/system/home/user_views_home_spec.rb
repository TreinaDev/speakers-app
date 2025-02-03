require 'rails_helper'

describe 'User views the home page', type: :system do
  it 'with success' do
    visit root_path

    expect(page).to have_content('Facilite sua jornada como palestrante: Organize e Ensine!')
    expect(page).to have_content('Um portal completo para gerenciar suas palestras, tarefas e conteúdos, além de acompanhar eventos de forma integrada.')
    expect(page).to have_content('Cadastre-se Agora')
    expect(page).to have_content('Tudo o que você precisa para brilhar como palestrante, em um só lugar.')
    expect(page).to have_content('Nosso sistema foi projetado pensando nas necessidades dos palestrantes. Aqui, você pode gerenciar todas as suas atividades, criar conteúdos para suas apresentações e acompanhar eventos de forma integrada.')
    expect(page).to have_content('Gerenciamento de Tarefas')
    expect(page).to have_content('Planeje suas palestras com facilidade.')
    expect(page).to have_content('Criação de Conteúdos')
    expect(page).to have_content('Organize materiais exclusivos para seus participantes.')
    expect(page).to have_content('Eventos Integrados')
    expect(page).to have_content('Receba informações automáticas sobre os eventos em que você vai ensinar.')
    expect(page).to have_content('Como funciona?')
    expect(page).to have_content('Crie sua conta e comece a planejar.')
    expect(page).to have_content('Registre-se em poucos cliques e comece a organizar suas atividades. Para se cadastrar é necessario que um organizador de evento tenha cadastrado seu email previamente.')
    expect(page).to have_content('Crie seu perfil.')
    expect(page).to have_content('Cadastre um perfil que ficará visível para todos os participantes dos seus eventos.')
    expect(page).to have_content('Cadastre tarefas e conteúdos.')
    expect(page).to have_content('Armazene tudo o que você precisa para sua palestra em um só lugar.')
    expect(page).to have_content('Integração com eventos.')
    expect(page).to have_content('Receba informações sobre onde e quando você vai ensinar.')
    expect(page).to have_content('Pronto para transformar suas palestras?')
    expect(page).to have_content('Junte-se a outros palestrantes que já estão usando nosso sistema para simplificar sua rotina e entregar mais valor aos seus participantes.')
    expect(page).to have_content('© Copyright 2025 Palestra+ | Todos os direitos reservados')
  end
end
