class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :check_if_have_an_existing_profile, except: :show

  def show
    # resolver erro quando não encontrar
    @profile = Profile.find_by(username: params[:username])
    @events = Event.all
  end
  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(profile_params)
    create_networks(params[:profile][:social_networks])

    if @profile.save
      redirect_to events_path, notice: "Perfil cadastrado com sucesso."
    else
      flash.now[:alert] = "Falha ao registrar o perfil."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:title, :about_me, :profile_picture)
  end

  def check_if_have_an_existing_profile
    redirect_to events_path, alert: 'Só é possível cadastrar um perfil.' if user_signed_in? && current_user.profile.present?
  end

  def create_networks(networks)
    networks.each do |_, network_data|
      url = network_data[:url]
      next if url.blank?
      @profile.social_networks.build(url: url, social_network_type: network_data[:social_network_type].to_i)
    end
  end
end
