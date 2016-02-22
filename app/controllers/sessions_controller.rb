class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy, :submit, :copy]
  before_action :set_mesh, only: [:index, :new, :create]

  # GET /sessions
  # GET /sessions.json
  def index
    @sessions = @mesh.sessions.preload(:jobs)
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
  end

  # GET /sessions/new
  def new
    @session = @mesh.sessions.build
  end

  # GET /sessions/1/edit
  def edit
  end

  # POST /sessions
  # POST /sessions.json
  def create
    @session = @mesh.sessions.build(session_params)

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: 'Session was successfully created.' }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sessions/1
  # PATCH/PUT /sessions/1.json
  def update
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to @session, notice: 'Session was successfully updated.' }
        format.json { render :show, status: :ok, location: @session }
      else
        format.html { render :edit }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    respond_to do |format|
      if @session.destroy
        format.html { redirect_to mesh_sessions_url(@mesh), notice: 'Session was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to mesh_sessions_url(@mesh), alert: "Session failed to be destroyed: #{@session.errors.to_a}" }
        format.json { render json: @session.errors, status: :internal_server_error }
      end
    end
  end

  # PUT /sessions/1/submit
  # PUT /sessions/1/submit.json
  def submit
    respond_to do |format|
      if @session.submitted?
        format.html { redirect_to mesh_sessions_url(@mesh), alert: 'Session has already been submitted.' }
        format.json { head :no_content }
      elsif @session.submit
        format.html { redirect_to mesh_sessions_url(@mesh), notice: 'Session was successfully submitted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to mesh_sessions_url(@mesh), alert: "Session failed to be submitted: #{@session.errors.to_a}" }
        format.json { render json: @session.errors, status: :internal_server_error }
      end
    end
  end

  # PUT /sessions/1/copy
  def copy
    @session = @session.copy

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: 'Session was successfully copied.' }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { redirect_to mesh_sessions_url(@mesh), alert: "Session failed to be copied: #{@session.errors.to_a}" }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.preload(:jobs).find(params[:id])
      @mesh = @session.parent
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_mesh
      @mesh = Mesh.preload(:jobs).find(params[:mesh_id])
    end

    # Only allow a trusted parameter "white list" through.
    def session_params
      params.require(:session).permit!
    end
end