class OtpsController < ApplicationController
  def show
    current_user.generate_otp
    if current_user.signed_with_email
      UserMailer.with(user: current_user).confirmation.deliver
    else

      message = %{
        Palkad.com
        confirm account
        https://www.palkad.com/otp/#{current_user.otp}/confirm

      }

      requested_url = 'https://api.textlocal.in/send/?'
                 
      uri = URI.parse(requested_url)
      http = Net::HTTP.start(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
       
      res = Net::HTTP.post_form(uri, 
        'apikey' => 'sy5OPGumyHI-2bNIEzDfny2v9FZdvOG3VRH4yaT1fP',
        'message' => message,
        #'sender' => 'palkad',
        'numbers' => current_user.email)
      response = JSON.parse(res.body)
      flash[:notice] = 'A new password is sent to your registered phone number'
    end
    redirect_to root_path
  end

  def confirm
    User.find_by_otp(params[:id]).update(otp: nil)
    redirect_to root_path
  end
end