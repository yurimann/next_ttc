module ApplicationHelper
  require 'net/http'
  def convert_xml(raw_data)
    data_holder = []
    #raw data comes from the TTC api in XML. Convert to ruby format with Nokogiri then into a hash so that it can be parsed.
    raw_data.each do |data|
      data_from_ttc = Net::HTTP.get(data)
      xml_doc = Nokogiri::XML(data_from_ttc)
      converted_data = Hash.from_xml(xml_doc.to_s)
      data_holder << converted_data
    end
    data_holder
  end

  def read_hash(feed)
    result = []
    feed.each do |converted_data|
      details = converted_data["body"]["predictions"]["direction"]["prediction"]
      details.each do |d|
        result << d
      end
    end
    result
  end

  def collate(parsed_data)
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
  end

  def interpret(parsed_data)
    # data is presented as ["north", 75]
    case parsed_data[1]
      when "65"
        x = {"north": "6298", "south": "14163" }
      when "75"
        x = {"north": "10013", "south": "8539" }
      else
        return "error"
      end

    if x[parsed_data[0].to_sym] != nil
      raw_data = [URI('http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=ttc&r=' + parsed_data[1] + '&s=' + x[parsed_data[0].to_sym])]
    else
      "error"
    end
  end

end
