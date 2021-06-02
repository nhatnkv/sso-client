class TaskController < ApplicationController
  before_action :authenticate_user!

  def index
    response = Faraday.get('http://localhost:3000/task/index')
    @tasks = JSON.parse(response.body)
  end
end
