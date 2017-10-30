require 'nokogiri'
require 'open-uri'
require 'pp'

URL = 'http://gateway.sonic.net/xslt?PAGE=C_1_0'

class Pace
  def parse_stats
    text = open(URL).read
    doc = Nokogiri::HTML.parse(text)

    data = []
    doc.search("table").each do |t|
      t.search("tr").each do |r|
          data << r.search("td").map{|d| d.inner_text}
      end
    end

    data_hash = data.inject(Hash.new) do |arr,i|
      key = i.shift.gsub(":", "").gsub(" ", "_").downcase
      arr[key] = i

      arr
    end

    data_hash
  end

  def gather
    data_hash = parse_stats
    statistics = []

    ["transmit", "receive"].map do |key|
      keys = data_hash["ip_traffic"]
      values = data_hash[key].clone
      keys.map do |i|
        name = i.downcase

        if name == "%"
          name = "percentage"
        end

        value = values.shift

        statistics << "# HELP #{key}_#{name}_total #{name} total.\n"
        statistics << "# TYPE #{key}_#{name}_total counter\n"
        statistics << "#{key}_#{name}_total #{value}\n"

      end

    end

    statistics
  end
end
