module Api
    module V1
        class UsersController < ApplicationController
            require "google/cloud/firestore"
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
                firestore = Google::Cloud::Firestore.new(
                    project_id: "simpe-web-chat",
                    credentials: 'D:\web-chat-be\simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json'
                )

                # Get a collection reference
                messages_col = firestore.col "users"

                # Get a document reference with data
                random_ref = messages_col.add({ 
                    photo_url: params[:photo_url],
                    username: params[:username],
                })
            end

            def update
                firestore = Google::Cloud::Firestore.new(
                    project_id: "simpe-web-chat",
                    credentials: 'D:\web-chat-be\simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json'
                )

                # Get a document reference
                user_ref = firestore.doc "users/#{params[:id]}"

                if  params[:username] && params[:photo_url]
                    user_ref.set({ username: params[:username],photo_url: params[:photo_url] }, merge: true)
                elsif params[:username]
                    user_ref.set({ username: params[:username]}, merge: true)
                else
                    user_ref.set({ photo_url: params[:photo_url] }, merge: true)
                end

                render json: {
                    "photo_url" => "#{params[:photo_url]}",
                    "username" => "#{params[:username]}",
                    "id" => "#{params[:id]}"
                }
            end

            def destroy
                firestore = Google::Cloud::Firestore.new(
                    project_id: "simpe-web-chat",
                    credentials: 'D:\web-chat-be\simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json'
                )

                # Get a document reference
                user_ref = firestore.doc "users/#{params[:id]}"
                user_ref.delete

                render json: {
                    "success" => true,
                    "id" => "#{params[:id]}"
                }
            end

        end
    end
end