class GraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    render json: Schema.execute(
      params[:query],
      variables: params[:variables] || {}
    )
  end

end 