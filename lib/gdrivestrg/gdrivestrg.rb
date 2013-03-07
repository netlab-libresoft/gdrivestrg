require 'cloudstrg/cloudstrg'

class GdriveStrg < CloudStrg::CloudStorage
  require 'google/api_client'

  CLIENT_ID = "867108581948.apps.googleusercontent.com"
  CLIENT_SECRET = "Z3TXaBvx36ex8RRD-Wu-3PGK"
  SCOPES = [
      'https://www.googleapis.com/auth/drive',
      'https://www.googleapis.com/auth/drive.file', # we will only see the files createdby this app
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile'
  ]

  def initialize params
    @client = Google::APIClient.new
    @drive_api = @client.discovered_api('drive', 'v2')
    @auth_api = @client.discovered_api('oauth2', 'v2')
    
    @client.authorization.client_id = CLIENT_ID
    @client.authorization.client_secret = CLIENT_SECRET
    #@client.authorization.redirect_uri = @secrets.redirect_uris.first
    @client.authorization.scope = SCOPES
  end

  def config params
    @client.authorization.redirect_uri =  params[:redirect]
    
    @user = params[:user]
    user_params = @user.gdrivestrgparams
    if not user_params
      user_params = @user.build_gdrivestrgparams
    end

    session = params[:session]

    if params[:code]
      authorize_code(params[:code])

      session[:gdrive_access_token] = @client.authorization.access_token
      # user.gdrive_access_token = @client.authorization.access_token
      user_params.refresh_token = @client.authorization.refresh_token
      user_params.expires_in = @client.authorization.expires_in
      user_params.issued_at = @client.authorization.issued_at
      user_params.save()
    elsif params[:error] # User denied the oauth grant
      puts "Denied: #{params[:error]}"
    else
      if params[:refresh_token] and params[:expires_in]
        user_params.refresh_token = params[:refresh_token]
        user_params.expires_in = params[:expires_in]
        user_params.save()
        user_params.issued_at = user_params.updated_at
        user_params.save()
      end
      if params[:access_token]
        session[:gdrive_access_token] = params[:access_token]
      end
      @client.authorization.update_token!(:access_token => session[:gdrive_access_token] , #:access_token => user_params.access_token, 
                                     :refresh_token => user_params.refresh_token, 
                                     :expires_in => user_params.expires_in, 
                                     :issued_at => user_params.issued_at)
      if @client.authorization.refresh_token && @client.authorization.expired?
        session = requestAccessToken(session, user_params)
      else
        if not authorized?
          if @client.authorization.refresh_token
            session = requestAccessToken(session, user_params)
          else
            session[:plugin_name] = self.class.to_s.split('Strg')[0].downcase
            return session, auth_url
          end
        else
          begin
            @client.execute!(:api_method => @auth_api.userinfo.get)
          rescue Exception => e
            session.delete(:gdrive_access_token)
            session = requestAccessToken(session, user_params)
          end
        end
      end
    end
    return session, false
  end

  def create_file params
    filename = params[:filename]

    file = @drive_api.files.insert.request_schema.new({'title' => filename, 'description' => 'Netlab scenario', 'mimeType' => 'text/json'})
    media=Google::APIClient::UploadIO.new(StringIO.new(params[:file_content]), 'text/json')
    r = @client.execute(:api_method => @drive_api.files.insert, :body_object => file, :media => media, :parameters => {'uploadType' => 'multipart', 'alt' => 'json'})
    if r.status != 200
      return false
    end
    return save_remoteobject(@user, filename, params[:file_content], r.data.id)
    
  end

  #def create_folder params
  #end

  def get_file params
    r = @client.execute!(:api_method => @drive_api.files.get, :parameters => {'fileId' => params[:fileid]})
    if r.status != 200
      return nil, nil, nil
    end
    filename = r.data.title
    r = @client.execute!(:uri => r.data.download_url)
    if r.status != 200
      return nil, nil, nil
    end

    return filename, params[:fileid], r.body
  end

  def update_file params
    filename = params[:filename]

    file = @drive_api.files.insert.request_schema.new({'title' => filename, 'description' => 'Netlab scenario', 'mimeType' => 'text/json'})
    media=Google::APIClient::UploadIO.new(StringIO.new(params[:file_content]), 'text/json')
    r = @client.execute(:api_method => @drive_api.files.update, :body_object => file, :media => media, :parameters => {'fileId' => params[:fileid], 'uploadType' => 'multipart', 'alt' => 'json'})
    if r.status != 200
      return false
    end
    return save_remoteobject(@user, filename, params[:file_content], params[:file_id])
    
  end

  def remove_file params
    r = @client.execute!(:api_method => @drive_api.files.delete, :parameters => {'fileId' => params[:fileid]})
  end

  def list_files
    r=@client.execute!(:api_method => @drive_api.files.list)
    if r.status != 200
      return []
    end
    
    lines = []
    r.data.items.each do |line|
      lines.append([line.title, line.id])
    end
    return lines
  end

  def share_file params
    new_permission = @drive_api.permissions.insert.request_schema.new({'value' => params[:share_email], 'type' => 'user', 'role' => 'writer'})
    result = @client.execute!(
      :api_method => @drive_api.permissions.insert,
      :body_object => new_permission,
      :parameters => { 'fileId' => params[:file_id] })
    if result.status == 200
      return result.data[:id]
    else
      puts "An error occurred: #{result.data['error']['message']}"
      return nil
    end

  end

  def check_referer referer
    if not referer
      return false
    end
    return referer.include? "accounts.google.com"
  end



  def authorized?
    return @client.authorization.refresh_token && @client.authorization.access_token
  end

  def authorize_code(authorization_code)
    @client.authorization.code = authorization_code
    @client.authorization.fetch_access_token!
  end

  def auth_url(state = '')
    return @client.authorization.authorization_uri().to_s
  end

  def requestAccessToken(session, user_params)
    @client.authorization.fetch_access_token!
    session[:gdrive_access_token] = @client.authorization.access_token
    # user.gdrive_access_token = @client.authorization.access_token
    user_params.refresh_token = @client.authorization.refresh_token
    user_params.expires_in = @client.authorization.expires_in
    user_params.issued_at = @client.authorization.issued_at
    user_params.save()
    return session
  end
end
