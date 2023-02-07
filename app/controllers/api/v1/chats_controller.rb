module Api
    module V1
        class ChatsController < ApplicationController
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
                    credentials: "#{File.expand_path("#{__dir__}/../../../../")}/simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json"
                )

                time = DateTime.parse(params[:time])
                # Get a collection reference
                messages_col = firestore.col "messages"

                # Get a document reference with data
                random_ref = messages_col.add({ 
                    message_text: params[:message_text],
                    username: params[:username],
                    time: time
                })

                if random_ref.document_id
                render json: {
                    "success" => true,
                    "id" => random_ref.document_id
                }
                else
                render json: {
                        "success" => false,
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
                firestore = Google::Cloud::Firestore.new(
                    project_id: "simpe-web-chat",
                    credentials: "#{File.expand_path("#{__dir__}/../../../../")}/simpe-web-chat-firebase-adminsdk-kmipu-6af2cbce99.json"
                )

                # Get a document reference
                chat_ref = firestore.doc "messages/#{params[:id]}"
                chat_ref.delete

                render json: {
                    "success" => true,
                    "id" => "#{params[:id]}"
                }
            end

        end
    end
end