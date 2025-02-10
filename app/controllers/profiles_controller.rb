class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :check_if_have_an_existing_profile, except: :show
  skip_before_action :check_if_user_has_profile
  skip_before_action :set_breadcrumb

  def show
    @profile = Profile.find_by(username: params[:username])
    return redirect_to events_path, alert: t('profiles.show.error', profile: params[:username]) if @profile.nil? && user_signed_in?
    return redirect_to root_path, alert: t('profiles.show.error', profile: params[:username]) if @profile.nil?
    @events = Event.all(@profile.user.token).sort_by { |event| event.start_date }.reverse
    @paginated_events = Kaminari.paginate_array(@events).page(params[:page]).per(15)
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
    filtered_params = params.require(:profile).permit(:title, :about_me, :profile_picture, :pronoun, :city, :birth,
                                                      :gender, :display_birth, :display_city, :display_gender, :display_pronoun)
    filtered_params[:pronoun] = params[:profile][:other_pronoun] if filtered_params[:pronoun] == t('profiles.pronoun_options.other')
    filtered_params[:gender] = params[:profile][:other_gender] if filtered_params[:gender] == t('profiles.gender_options.other')
    filtered_params
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
