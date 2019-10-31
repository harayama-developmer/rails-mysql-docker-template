class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :done, :undo]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.where(is_done: false).order(created_at: :desc)
    @done_tasks = Task.where(is_done: true).order(:updated_at)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'タスクを追加しました。' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'タスクを更新しました。' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'タスクを削除しました。' }
      format.json { head :no_content }
    end
  end

  ### 追加したアクション

  # タスクを完了する
  def done
    if @task.done
      redirect_to tasks_path, notice: 'タスクを完了しました。'
    else
      redirect_to tasks_path, notice: 'タスクを完了できませんでした。'
    end
  end

  # タスクを未完了に戻す
  def undo
    if @task.undo
      redirect_to tasks_path, notice: 'タスクを未完了に戻しました。'
    else
      redirect_to tasks_path, notice: 'タスクを未完了に戻せませんでした。'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :assignee_id)
    end
end
