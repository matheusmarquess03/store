class ApplicationController < ActionController::API
  before_action :check_session_timeout

  # before_action :authorize
  # protected
  #
  # def authorize
  #   unless User.find_by(id: session[:user_id])
  #     redirect_to login_url, notice: "Please log in"
  #   end
  # end

  private

  def check_session_timeout
    # Certifica-se de que session[:last_activity_time] seja um objeto Time
    session[:last_activity_time] = Time.parse(session[:last_activity_time]) if session[:last_activity_time].is_a?(String)

    # Define o horário da última atividade se não existir
    session[:last_activity_time] ||= Time.current

    # Verifica se o tempo de inatividade é superior a 30 minutos
    if Time.current - session[:last_activity_time] > 30.minutes
      reset_session  # Expira a sessão
      render json: { error: "Sua sessão expirou devido à inatividade." }, status: :unauthorized
    else
      session[:last_activity_time] = Time.current
    end
  end
end
