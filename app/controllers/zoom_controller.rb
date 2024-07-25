class ZoomController < ApplicationController
  def auth
    client_id = ENV['CLIENT_ZOOM_ID']
    client_secret = ENV['CLIENT_ZOOM_SECRET']
    redirect_uri = ENV['CLIENT_ZOOM_REDIRECT_URI']
    zoom_authorize_url = "https://zoom.us/oauth/authorize?client_id=#{client_id}&response_type=code&redirect_uri=#{redirect_uri}"
    redirect_to zoom_authorize_url, allow_other_host: true
  end

  def zoom_callback
    code = params[:code]
    access_token = get_access_token(code)
    if access_token
      session[:zoom_access_token] = access_token
      api_endpoint_url = "https://api.zoom.us/v2/users/me"
      serialized_response = RestClient.get(
        api_endpoint_url,
        {
          Authorization: "Bearer #{access_token}",
          content_type: "application/json",
          accept: :json
        }
      )
      response = JSON.parse(serialized_response)
      personal_meeting_url = response["personal_meeting_url"]
      if personal_meeting_url
        @user_bookings = Booking.where(interviewee: current_user)
        @user_bookings.last.update(meeting_link: personal_meeting_url)
        redirect_to myinterviews_path
      end
    else
      flash[:alert] = "There was an error authenticating with Zoom. Please try again."
    end
  end

  def get_access_token(code)
    client_id = ENV['CLIENT_ZOOM_ID']
    client_secret = ENV['CLIENT_ZOOM_SECRET']
    redirect_uri = ENV['CLIENT_ZOOM_REDIRECT_URI']

    zoom_token_url = "https://zoom.us/oauth/token"

    credentials = Base64.strict_encode64("#{client_id}:#{client_secret}")

    serialized_response = RestClient.post(
      zoom_token_url,
      {
        grant_type: 'authorization_code',
        code: code,
        redirect_uri: redirect_uri
      },
      {
        Authorization: "Basic #{credentials}",
        content_type: 'application/x-www-form-urlencoded',
        accept: :json
      }
    )
    response = JSON.parse(serialized_response)
    response['access_token']
  end
end
