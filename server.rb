require 'sinatra'
require 'pry'


get '/' do

  erb :index
end

get '/articles/new' do

  erb :form
end

get '/articles' do
  @csv_file = File.read("articles.csv").split("\n")

  erb :articles
end

post '/articles/new' do

  def error_message(title, url, description)
    error_hash = Hash.new
    full_hash = Hash.new
    @post_array = Array.new
    error_hash = {"title_name" => title, "url_name" => url}
    full_hash = {"title_name" => title, "url_name" => url, "description" => description}
    com_check = error_hash["url_name"].split(".")

        unless com_check.any? { |x| ["com", "org", "net", "ninja"].include?(x) }
          @post_array << "error: not a valid url"
        end

        @url_titles = File.read("url_titles.csv")
        if @url_titles.include?(@url_name)
          @post_array << "error: article already posted"
        else
          File.open("url_titles.csv", "a"){|file| file.puts "#{@url_name}"}
        end

        full_hash.each do |keys, values|
          if values == ""
            @post_array << "error: blank field"
          end
        end
    @post_array
  end

  @title_name = params["title_name"]
  @url_name = params["url_name"]
  @description = params["description"]

  @errors = error_message(@title_name, @url_name, @description)

    if @errors.any?
      erb :form
    else
      File.open("articles.csv", "a"){|file| file.puts "#{@title_name}, #{@url_name}, #{@description}"}
      @csv_file = File.read("articles.csv").split("\n")
      erb :articles
    end

end
