class OkiniirisController < ApplicationController
  before_action :require_user_logged_in
    
  def create
    #ここからmodelのuserのokini_toroku()をよぶ
    current_user.okini_toroku(params[:micropost_id])
    flash[:success] = 'お気に入りに登録しました。'
    redirect_back(fallback_location: root_path) #登録を押したページへ戻す
  end

  def destroy
    puts 'お気に入りdestroy'
    current_user.okini_hazusi(params[:id])
    flash[:success] = 'お気に入りから外しました。'
    redirect_back(fallback_location: root_path)
  end
end
