class ProfilesController < ApplicationController
  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(profile_params)

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
end
