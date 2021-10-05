module Admin
  class UsersController < BaseController
    before_action :load_user, only: %i(show edit update destroy)
    before_action :check_file_csv, only: :import

    def index
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true)

      respond_to do |format|
        format.html
        format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" }
      end
    end


    def show
    end

    def import
      User.import_file params[:file]
      redirect_to admin_users_path, notice: I18n.t('common.data_imported')
    end

    def new
      @user = User.new
    end
    
    def create
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = I18n.t('admin.managament.user.create_success')
        redirect_to admin_users_path
      else
        render 'new'
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        flash[:notice] = I18n.t('admin.managament.user.profile_updated')
        redirect_to admin_users_path
      else
        render 'edit'
      end
    end

    def destroy
      @user.destroy
      flash[:notice] = I18n.t('admin.managament.user.user_deleted')
      redirect_to admin_users_path
    end
  
    private

    def user_params
      params.require(:user).permit(:name, :email, :address,:phone, :birthday, :admin, :password, :password_confirmation)
    end 

    def load_user
      @user = User.find_by(id: params[:id])
      return if @user
      render 'devise/shared/not_found'
    end

    def check_file_csv
      unless File.extname(params[:file].original_filename) == '.csv'
        redirect_to admin_users_path, notice: I18n.t('admin.managament.csv.errors.not_csv')
        return
      end
    end
  end
end  
