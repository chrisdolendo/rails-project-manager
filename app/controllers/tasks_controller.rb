class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:index, :create]

  def index
    @tasks = @project.tasks
    render template: 'tasks/index.html.erb', layout: false 
  end

  def create
    @task = Task.create(task_params)
    @project.tasks << @task
    redirect_to project_path(@project)
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
    end    
  end 

  private
      # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :difficulty_level)
  end

  def set_project 
    @project = Project.find(params[:project_id])
  end

end
