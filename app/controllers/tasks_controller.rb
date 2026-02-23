def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        # WE CHANGED THIS LINE RIGHT HERE:
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end