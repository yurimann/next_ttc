class ResultsController < ApplicationController
  require 'net/http'
  skip_before_action :verify_authenticity_token

  def index
  end

  def next

    @result_string = ""
    parsed_data = helpers.parse_data(params[:text])

    if parsed_data.length == 1
      raw_data = helpers.collate(parsed_data)
    else
      raw_data = helpers.interpret(parsed_data)
      if raw_data == "error"
        @result_string = "Invalid route"
        respond_to do |format|
          format.html
          format.json {render json: @result_string}
        end
        return @result_string
      end
    end

    if params["content-type"] == nil
      params["content-type"] = "json"
    end

    complete_result = helpers.convert_xml(raw_data)
    result = helpers.read_hash(complete_result)
    res = result.sort_by {|obj| obj["minutes"]}
      @results = res[0..2]
    #this is the string that will be passed to slack.
    x = 0
    until x >= @results.length do

      complete_result.each do |res|

        if @results[x]["branch"] == res["body"]["predictions"]["routeTag"]
          location = res["body"]["predictions"]["stopTitle"]
          direction = res["body"]["predictions"]["direction"]["title"]

          temp = "#{direction} (#{@results[x]["vehicle"]}) from #{location} will arrive in #{@results[x]["minutes"]} minute/s " + "\n"
          @result_string += temp
        end
      end
      x += 1
    end

    respond_to do |format|
      format.html
      format.json {render json: @result_string}
    end

  end

end
