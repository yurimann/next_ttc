class ResultsController < ApplicationController
  require 'net/http'
  skip_before_action :verify_authenticity_token

  def index
    raw_data = [URI('http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=ttc&r=504&s=1581'), URI('http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=ttc&r=514&s=1581')]
    result = []
    @result_string = ""

    #raw data comes from the TTC api in XML. Convert to ruby format with Nokogiri then into a hash so that it can be parsed.
    raw_data.each do |data|
      data_from_ttc = Net::HTTP.get(data)
      xml_doc = Nokogiri::XML(data_from_ttc)
      converted_data = Hash.from_xml(xml_doc.to_s)
      details = converted_data["body"]["predictions"]["direction"]["prediction"]
      details.each do |d|
        result << d
      end
    end
      res = result.sort_by {|obj| obj["minutes"]}
      @results = res[0..2]
    #this is the string that will be passed to slack.
    x = 0
    until x >= @results.length do
      temp = "The #{@results[x]["branch"]} streetcar from King and Ontario to King Station will arrive in #{@results[x]["minutes"]} minute/s " + "\n"
      @result_string += temp
      x += 1
    end


    respond_to do |format|
      format.html
      format.json {render json: @result_string}
    end

  end

  def next
    if params[:text].downcase == "west"
      raw_data = [URI('http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=ttc&r=504&s=1581'), URI('http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=ttc&r=514&s=1581')]
    elsif params[:text].downcase == "east"
      raw_data = [URI('http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=ttc&r=504&s=3070'), URI('http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=ttc&r=514&s=3070')]
    else
      response_data = "Please choose west or east"
      respond_to do |format|
        format.json{render json: response_data}
      end
      return response_data
      render root_path
    end
    result = []
    @result_string = ""

    if params["content-type"] == nil
      params["content-type"] = "json"
    end
    #raw data comes from the TTC api in XML. Convert to ruby format with Nokogiri then into a hash so that it can be parsed.
    raw_data.each do |data|
      data_from_ttc = Net::HTTP.get(data)
      xml_doc = Nokogiri::XML(data_from_ttc)
      converted_data = Hash.from_xml(xml_doc.to_s)
      details = converted_data["body"]["predictions"]["direction"]["prediction"]
      details.each do |d|
        result << d
      end
    end
      res = result.sort_by {|obj| obj["minutes"]}
      @results = res[0..2]
    #this is the string that will be passed to slack.
    x = 0
    until x >= @results.length do
      if params[:text].downcase == "west"
        temp = "The #{@results[x]["branch"]} streetcar (#{@results[x]["vehicle"]}) from King and Ontario to King Station will arrive in #{@results[x]["minutes"]} minute/s " + "\n"
      elsif params[:text].downcase == "east"
        temp = "The #{@results[x]["branch"]} streetcar (#{@results[x]["vehicle"]}) from King Station to 351 King E will arrive in #{@results[x]["minutes"]} minute/s " + "\n"
      end
        @result_string += temp
        x += 1
    end

    respond_to do |format|
      format.html
      format.json {render json: @result_string}
    end

  end

end
