class UsersController < ApplicationController
#  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]
  before_action :require_user_logged_in, only: [:followings, :followers] #breadcrumbsテスト用


  # 第一引数にテキスト、第二にパスを入れる
  add_breadcrumb 'Home', '/'
  add_breadcrumb 'ユーザー一覧', :users_path
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    
    
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)

    @kiji_title = @user.name
    # 第二引数を省くとリンクではない階層を作れる、最後の階層はパスを入れてもリンクにならない
    add_breadcrumb @kiji_title, :user_path


  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def followings
    @user = User.find(params[:id])
    puts 'params[:id]は' +  params[:id]
    @followings = @user.followings.page(params[:page]) #app/models/user.rbのhas_manyで使えるようになったfollowingsメソッド
    counts(@user) #ツイート数、フォロワー数、フォロー数を全部とってくる
  end
  
  def followers
    @user = User.find(params[:id])
    puts 'params[:id]は' +  params[:id]
    @followers = @user.followers.page(params[:page]) #app/models/user.rbのhas_manyで使えるようになったfollowersメソッド
    counts(@user) #ツイート数、フォロワー数、フォロー数を全部とってくる
  end

  def okiniiris
    @user = User.find(params[:id]) #URLの/user/2のIDでユーザーを探してインスタンスを入れる
    @okinis = @user.get_okini_microposts.order('created_at DESC').page(params[:page]) #お気に入りテーブルの先にあるmicropostsインスタンスを取得 #okinisだとエラーがでるけど、@okinisだとエラーが出ないなぜ？
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
