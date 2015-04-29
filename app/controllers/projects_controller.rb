class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :screen_user_access
  before_action :screen_show_access, only: [:show]
  before_action :screen_modification_access, only: [:edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.page(params[:page]).per(10)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        ProjectUser.create(project_id: @project.id, user_id: current_user.id, role: Project.role_ranking("owner"))
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :project_users_attributes => [:id, :project_id, :user_id, :role, :_destroy])
    end

    def screen_user_access
      if current_user == nil
        redirect_to new_user_session_path
      end
    end

    def screen_show_access
      if current_user.is_admin? || ProjectUser.where(user_id: current_user.id, project_id: @project.id).any?
        return
      else
        flash[:alert] = "Unable to complete request. You do not have permissions to view this project."
        redirect_to projects_path and return
      end
    end

    def screen_modification_access
      if current_user.is_admin? || ProjectUser.where(user_id: current_user.id, project_id: @project.id, role: Project.role_ranking("owner") ).any?
        return
      else
        flash[:alert] = "Unable to complete request. You do not have permissions to view this project."
        redirect_to projects_path and return
      end      
    end


end
