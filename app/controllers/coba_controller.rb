class CobaController < ApplicationController
    include Coba
    def index
        result = {
            "gebetan" => "faustine"
        }
        render json: result
    end

    def show
        result = {
            "data" => "#{params[:id]}"
        }
        render json: result
        puts "halo faustine"
        puts "#{params[:id]}"
        # halo (method from Coba module)
    end

    def aneh
        result = {
            "data" => halo
        }
        render json: result
        puts result
    end
end

# how to pass body request in ruby controller ?