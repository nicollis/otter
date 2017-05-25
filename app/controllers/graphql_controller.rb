class GraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token

  SCHEMA = GraphQL::Api::Schema.new.schema 

  def create
    render json: SCHEMA.execute(
      params[:query],
      variables: params[:variables] || {}
    )
  end

end 