# TODO:
#       Make feature scenarios work.


class NetworkController < ApplicationController

  before_filter :must_be_logged_in
  helper_method :username_on_site_or_add_link

  # List the user's networks
  def index
    @user = current_user
    render 'signup/step2'
  end

  # Remove network from a user's account.
  def destroy
    @network = params[:network]
    @account = current_user.accounts[@network]
    SocialNetworkAccount.destroy(@account.id)
    flash[:notice] = "Successfully removed the #{@network} network"
    redirect_to :back
  end

  # Enter info to connect to a network.
  def new
    session[:referrer] = request.referrer
    @network = params[:network]
    @account = current_user.accounts[@network] || SocialNetworkAccount.create(:network_name => @network, :user => current_user)
    case @account.auth_type
    when :oauth
      if !@account.authenticated_to_network_site?
        begin
          @account.save
          url = @account.oauth_authorize_url(@account, network_oauth_url(:network => @network))
          redirect_to url
        rescue OAuth::Unauthorized => e # TODO: Handle OAuth::Problem and OAuth:Error as well.
          # TODO: Figure out how to handle this. This will only happen if the networking site rejects our OAuth consumer account.
          render :text => "#{network_oauth_url(:network => @network)}<br />\n" +
                          "#{e.inspect}<br />\n"
        end
      else
        redirect_to :back
      end
    when :facebook, :oauth2
      if !@account.authenticated_to_network_site?
        begin
          @account.save
          url = @account.oauth_authorize_url(@account, network_oauth2_url(:network => @network))
          redirect_to url
        rescue StandardError => e # OAuth2::AccessDenied => e # TODO: Handle OAuth2::ErrorWithResponse and OAuth2::HTTPError as well.
          # TODO: Figure out how to handle this. This will only happen if Twitter rejects our OAuth consumer account.
          render :text => "#{network_oauth_url(:network => @network)}\n#{e}"
        end
      else
        redirect_to :back
      end
    else
      # TODO: Non-OAuth authentication/authorization.
    end
  end

  # Process callback from OAuth authorization.
  def create_oauth
    @network = params[:network]
    if params[:denied]
      # User did not allow us access to their OAuth account.
      flash[:notice] = "You did not authorize us to access your #{@network} account"
      redirect_to session[:referrer]
      return
    end
    @account = current_user.accounts[@network]
    raise RuntimeError if @account.nil? # TODO: What should we do here?
    if @account.verify_oauth_result(@account, params)
      flash[:notice] = "Successfully added the #{@network} network"
      redirect_to session[:referrer]
    else
      flash[:notice] = "Something went wrong adding the #{@network} network"
      redirect_to session[:referrer]
    end
  rescue OAuth::Unauthorized => e # TODO: Handle OAuth::Problem and OAuth:Error as well.
    flash[:notice] = "You did not authorize us to access your #{@network} account!"
    redirect_to session[:referrer]
  end

  # Process callback from OAuth2 authorization.
  def create_oauth2
    @network = params[:network]
    if params[:denied]
      # User did not allow us access to their OAuth account.
      flash[:notice] = "You did not authorize us to access your #{@network} account"
      redirect_to session[:referrer]
      return
    end
    @account = current_user.accounts[@network]
    raise RuntimeError if @account.nil? # TODO: What should we do here?
    params[:callback_url] = network_oauth2_url(:network => @network)
    if @account.verify_oauth_result(@account, params)
      flash[:notice] = "Successfully added the #{@network} network."
      redirect_to session[:referrer]
    else
      flash[:notice] = "Something went wrong adding the #{@network} network"
      redirect_to session[:referrer]
    end
  rescue OAuth2::AccessDenied => e # TODO: Handle OAuth2::ErrorWithResponse and OAuth2::HTTPError as well.
    flash[:notice] = "You did not authorize us to access your #{@network} account!"
    redirect_to session[:referrer]
  end

  # Connect to a network with the given network credentials.
  def create
    @network = params[:network]
    @account = current_user.accounts[@network]
    raise RuntimeError if @account.nil? # TODO: What should we do here?
    # TODO: This stuff not tested yet.
    @account = SocialNetworkAccount.new(params[:user].merge(:network => @network))
    if @network.valid?
      @network.save!
      flash[:notice] = "Successfully added the #{@network.name} network"
      redirect_to session[:referrer]
    else
      render 'network/add'
    end
  end


protected

  def must_be_logged_in
    redirect_to home_path and return if !current_user
  end

end
