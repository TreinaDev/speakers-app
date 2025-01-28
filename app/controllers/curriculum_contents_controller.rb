class CurriculumContentsController < ApplicationController
  def new
    @curriculum = Curriculum.find(params[:curriculum_id])
    @event_contents = current_user.event_contents
    @curriculum_content = @curriculum.curriculum_contents.build
  end

  def create
    @curriculum = Curriculum.find(params[:curriculum_id])
    @curriculum_content = @curriculum.curriculum_contents.build(set_curriculum_content_params)

    return redirect_to schedule_item_path(@curriculum.schedule_item_code), notice: 'Conteúdo adicionado com sucesso!' if @curriculum_content.save

    @event_contents = current_user.event_contents
    flash.now[:alert] = 'Falha ao adicionar conteúdo.'
    render :new, status: :unprocessable_entity
  end

  private

  def set_curriculum_content_params
    params.require(:curriculum_content).permit(:event_content_id)
  end
end
