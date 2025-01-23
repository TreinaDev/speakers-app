class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_have_an_existing_profile
  # skip_before_action :redirect_if_dont_have_profile
  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(profile_params)
    networks = params[:profile][:social_networks]

    networks.each do |network_key, network_data|
      social_networks_params = network_data.permit(:url, :social_network_type)
      unless social_networks_params[:url].empty?
        @profile.social_networks.build(url: social_networks_params[:url], social_network_type: social_networks_params[:social_network_type].to_i)
      end
    end

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
    redirect_to events_path, alert: 'Só é possível cadastrar um perfil.' if current_user.profile.present?
  end
end
