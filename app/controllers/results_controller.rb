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
      @results = res[0..4]
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
      @results = res[0..4]
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

end
