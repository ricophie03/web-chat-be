module Api
    module V1
        class ChatsController < ApplicationController
            require 'firebase'
            def index
                render json: {
                    "connected" => "success"
                }
            end

            def show
                render json: {
                    "berhasil" => "success",
                    "id" => "#{params[:id]}"
                }
            end

            def create
                base_uri = 'https://simpe-web-chat-default-rtdb.firebaseio.com/'
                firebase = Firebase::Client.new(base_uri)
                response = firebase.push("messages", {
                    :message_text => params[:message_text],
                    :time => Firebase::ServerValue::TIMESTAMP,
                    :username => params[:username]
                })
                if response.code == 200
                   render json: {
                    "messages" => "successfully add chat to firebase",
                    "data" => response.body
                }
                end
            end

            def update
                render json: {
                    "message_text" => "#{params[:message_text]}",
                    "time" => "#{params[:time]}",
                    "username" => "#{params[:username]}",
                    "id" => "#{params[:id]}"
                }
            end

            def destroy
                render json: {
                    "success" => true,
                    "id" => "#{params[:id]}"
                }
            end

        end
    end
end