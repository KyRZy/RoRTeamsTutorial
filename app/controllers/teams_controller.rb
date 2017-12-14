require 'bcrypt'

class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :leave_team]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    # sprawdzenie czy hasła w obu polach są identyczne
    if params[:password] == params[:password_confirmation]
      @team = Team.new(team_params)
      # ustawienie obecnie zalogowanego użytkownika jako lidera drużyny
      @team.leader_id = current_user.id
      # wygenerowanie soli, unikalnej dla każdej drużyny
      @team.salt = BCrypt::Engine.generate_salt
      # zaszyfrowanie hasła wykorzystując sól
      @team.encrypted_password= BCrypt::Engine.hash_secret(params[:password], @team.salt)
      Team.transaction do
        respond_to do |format|
        # zapisanie drużyny w bazie danych
        if @team.save
          # ustawienie utworzonej drużyny jako drużynę zalogowanego użytkownika
          current_user.team_id = @team.id
            # zapisanie zmian w użytkowniku
            if current_user.save
              flash[:success] = 'Team was successfully created.'
              format.html { redirect_to root_url}
              format.json { render :show, status: :created, location: @team }
            else
              format.html { render :new }
              format.json { render json: current_user.errors, status: :unprocessable_entity }
            end
        # jeśli zapisanie drużyny nie powiodło się (wykorzystujemy fakt, że podczas walidacji sprawdzamy tylko unikalność nazwy)
        else
          flash[:error] = 'This team name is already taken.'
          format.html { render :new }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end
    end
    # sprawdzenie czy hasła w obu polach NIE są identyczne
    else
      flash[:error] = 'Password and password confirmation don\'t match.'
      redirect_to new_team_path
    end
  end

  def join_existing_team
    name = params[:name]
    password = params[:password]
    # changed "if team = Team.where(name: name).first" to make search case-insensivite
    if team = Team.where("LOWER(name) = ?",name.downcase).first
      if team.encrypted_password == BCrypt::Engine.hash_secret(password, team.salt)
        current_user.team_id = team.id
        respond_to do |format|
          if current_user.save
            flash[:success] = 'You successfully joined the team.'
            format.html { redirect_to team}
            format.json { render :show, status: :created, location: team }
          else
            format.html { render :new }
            format.json { render json: current_user.errors, status: :unprocessable_entity }
          end
        end
      else
        flash[:error] = 'Wrong password.'
        redirect_to new_team_path
      end
    else
      flash[:error] = 'Team does not exist.'
      redirect_to new_team_path
    end
  end

  def leave_team
    if current_user.team = @team
      current_user.team = nil
      respond_to do |format|
        if current_user.save
          flash[:success] = 'You successfully left the team.'
          format.html { redirect_to root_url}
          format.json { render :show, status: :created, location: @team }
        else
          format.html { render :new }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = 'You cannot leave the team you\'re not a member of.'
      redirect_to @team
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :encrypted_password, :salt, :leader_id)
    end
end
