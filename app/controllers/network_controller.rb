# TODO:
#       Make feature scenarios work.


class NetworkController < ApplicationController

  before_filter :must_be_logged_in
  helper_method :username_on_site_or_add_link

  # List the user's networks
  def index
    @networks = SocialNetworkSite.all
    render 'network/list'
  end

  # Enter info to connect to a network.
  def new
    @network = params[:network].downcase
    @account = current_user.accounts[@network] || SocialNetworkAccount.create(:network_name => @network, :user => current_user)
    case @account.auth_type
    when :oauth
      if !@account.authenticated_to_network_site?
        begin
          @account.save
          url = @account.oauth_authorize_url(@account, network_oauth_url(:network => @network))
          redirect_to url
        rescue OAuth::Unauthorized => e # TODO: Handle OAuth::Problem and OAuth:Error as well.
          # TODO: Figure out how to handle this. This will only happen if Twitter rejects our OAuth consumer account.
          render :text => "#{network_oauth_url(:network => @network)}\n#{e.inspect}"
        end
      else
        @username = @account.username # TODO: Temp, to make the username_on_site_or_add_link helper work.
        flash[:notice] = "You've already added the #{@network.humanize} network."
        redirect_to networks_path
      end
    else
      # TODO: Non-OAuth authentication/authorization.
    end
  end

  # Process callback from OAuth authorization.
  def create_oauth
    @network = params[:network].downcase
    if params[:denied]
      # User did not allow us access to their OAuth account.
      flash[:notice] = "You did not authorize us to access your #{@network.humanize} account"
      redirect_to networks_path
      return
    end
    @account = current_user.accounts[@network]
    raise RuntimeError if @account.nil? # TODO: What should we do here?
    if @account.verify_oauth_result(@account, params)
      flash[:notice] = "Successfully added the #{@network.humanize} network"
      redirect_to networks_path
    else
      flash[:notice] = "Something went wrong adding the #{@network.humanize} network"
      redirect_to networks_path
    end
  rescue OAuth::Unauthorized => e # TODO: Handle OAuth::Problem and OAuth:Error as well.
    flash[:notice] = "You did not authorize us to access your #{@network.humanize} account!!!!"
    redirect_to networks_path
  end

  # Connect to a network with the given network credentials.
  def create
    @network = params[:network].downcase
    @account = current_user.accounts[@network]
    raise RuntimeError if @account.nil? # TODO: What should we do here?
    # TODO: This stuff not tested yet.
    @account = SocialNetworkAccount.new(params[:user].merge(:network => @network))
    if @network.valid?
      @network.save!
      flash[:notice] = "Successfully added the #{@network.name} network"
      redirect_to networks_path
    else
      render 'network/add'
    end
  end


protected

  def must_be_logged_in
    redirect_to home_path and return if !current_user
  end

end
