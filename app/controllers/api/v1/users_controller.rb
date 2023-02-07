module Api
    module V1
        class UsersController < ApplicationController
            require "google/cloud/firestore"
            require "google/cloud/storage"

            def index
                storage  = Google::Cloud::Storage.new(
                    project_id: "simpe-web-chat",
                    credentials: "#{File.expand_path("#{__dir__}/../../../../")}/simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json"
                )

                # # Get a bucket reference
                # bucket = storage.bucket "simpe-web-chat.appspot.com"
                # file = bucket.file "images/1.png"

                render json: {
                    "connected" => "success"
                    # "bucket" => file.public_url
                }
            end

            def show
                storage  = Google::Cloud::Storage.new(
                    project_id: "simpe-web-chat",
                    credentials: "#{File.expand_path("#{__dir__}/../../../../")}/simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json"
                )

                render json: {
                    "berhasil" => "success",
                    "id" => "#{params[:id]}",
                }
            end

            def create
                if params[:image_name] #if photo uploaded
                    storage  = Google::Cloud::Storage.new(
                        project_id: "simpe-web-chat",
                        credentials: "#{File.expand_path("#{__dir__}/../../../../")}/simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json"
                    )
    
                    # Get a bucket reference
                    bucket = storage.bucket "simpe-web-chat.appspot.com"
                    file = bucket.create_file "C:\\Pictures\\#{params[:image_name]}",
                    "images/#{params[:username]}_#{params[:image_name]}"
    
                    if file.url
                        firestore = Google::Cloud::Firestore.new(
                            project_id: "simpe-web-chat",
                            credentials: "#{File.expand_path("#{__dir__}/../../../../")}/simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json"
                        )
    
                        # Get a collection reference
                        users_col = firestore.col "users"
    
                        # Get a document reference with data
                        random_ref = users_col.add({ 
                            photo_url: file.url,
                            username: params[:username]
                        })
    
                        render json: {
                            "image_url" => file.url,
                            "username" => params[:username],
                            "id" => random_ref.document_id,
                            "success" => true
                        }
                    else
                        render json: {
                            "success" => false
                        }
                    end
                else #if photo is empty
                    firestore = Google::Cloud::Firestore.new(
                        project_id: "simpe-web-chat",
                        credentials: "#{File.expand_path("#{__dir__}/../../../../")}/simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json"
                    )

                    # Get a collection reference
                    users_col = firestore.col "users"

                    # Get a document reference with data
                    random_ref = users_col.add({ 
                        photo_url: "",
                        username: params[:username]
                    })

                    if random_ref.document_id
                        render json: {
                            "image_url" => "",
                            "username" => params[:username],
                            "id" => random_ref.document_id,
                            "success" => true
                        }
                    else
                        render json: {
                            "success" => false
                        }
                    end
                end
            end

            def update
                storage = Google::Cloud::Storage.new.new(
                    project_id: "simpe-web-chat",
                    credentials: "#{File.expand_path("#{__dir__}/../../../../")}/simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json"
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
                storage = Google::Cloud::Storage.new.new(
                    project_id: "simpe-web-chat",
                    credentials: "#{File.expand_path("#{__dir__}/../../../../")}/simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json"
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