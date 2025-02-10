class CertificatesController < ApplicationController
  skip_before_action :set_breadcrumb
  def index; end

  def search
    @certificate = Certificate.find_by(token: params[:query])
    return render :index if @certificate

    redirect_to certificates_path, alert: t('.index.certificate_not_found')
  end

  def show
    @certificate = Certificate.find_by(token: params[:token])

    unless @certificate
      return redirect_to certificates_path, alert: 'Certificado não encontrado.'
    end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "certificado_#{@certificate.token}",
               template: "certificates/show",
               formats: [ :html ],
               orientation: "Landscape",
               disposition: 'inline',
               layout: 'pdf',
               margin: { top: 0, bottom: 0, left: 0, right: 0 }
        end
    end
  end
end
