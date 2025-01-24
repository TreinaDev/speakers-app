class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :check_if_have_an_existing_profile, except: :show

  def show
    @profile = Profile.find_by(username: params[:username])
    redirect_to root_path, alert: t('profiles.show.error', profile: params[:username]) if @profile.nil?
    @events = Event.all
  end
  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(profile_params)
    create_networks(params[:profile][:social_networks])

    if @profile.save
      redirect_to events_path, notice: t('profiles.create.success')
    else
      flash.now[:alert] = t('profiles.create.error')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:title, :about_me, :profile_picture)
  end

  def check_if_have_an_existing_profile
    redirect_to events_path, alert: t('profiles.check_if_have_an_existing_profile') if user_signed_in? && current_user.profile.present?
  end

  def create_networks(networks)
    networks.each do |_, network_data|
      url = network_data[:url]
      next if url.blank?
      @profile.social_networks.build(url: url, social_network_type: network_data[:social_network_type].to_i)
    end
  end
end
