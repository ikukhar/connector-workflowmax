class OauthController < ApplicationController

  # TODO
  # Routes for this controller are not provided by the gem and
  # should be set according to your needs

  def request_omniauth
    if is_admin
      # TODO
      # Perform oauth request here. The oauth process should be able to
      # remember the organization, either by a param in the request or using
      # a session
    else
      redirect_to root_url
    end
  end

  def create_omniauth
    org_uid, client_id, client_secret = params[:org_uid], params[:client_id], params[:client_secret]
    if WorkflowmaxClient.auth_check(client_id, client_secret)
    organization = Maestrano::Connector::Rails::Organization.find_by_uid_and_tenant(org_uid, current_user.tenant)
      if organization && is_admin?(current_user, organization)
        begin
          organization.update(oauth_uid: client_id, oauth_token: client_secret, oauth_provider: 'workflowmax')
        rescue => e
          Rails.logger.info "Error in create_omniauth: #{e}. #{e.backtrace}"
          flash[:danger] = 'Error saving credentials'
        end
      end
    else
      flash[:danger] = 'Error auth checking'
    end

    redirect_to root_url
  end

  def destroy_omniauth
    organization = Maestrano::Connector::Rails::Organization.find_by_id(params[:organization_id])

    if organization && is_admin?(current_user, organization)
      organization.oauth_uid = nil
      organization.oauth_token = nil
      organization.refresh_token = nil
      organization.sync_enabled = false
      organization.oauth_provider = nil
      organization.save
    end

    redirect_to root_url
  end
end
