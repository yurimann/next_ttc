module ResultsHelper
  def parse_data(info)
    result = []
    inf = info.split(" ")
    if inf.length > 2
      return "Invalid arguments"
    end
    x = 0
    until x >= inf.length do
      i = inf[x].downcase
      if i == "north" || i == "east" || i == "west" || i == "south"
        result[0] = i
      elsif i.to_i > 0
        if result[0] == nil
          result[0] = ""
        end
        result[1] = i
      else
        return "invalid value #{i}"
      end
      x += 1
    end
    result
  end

end
