#encoding: utf-8
module AreaSelectCn
  class Id
    Root = "000000"
    attr_reader :id,:data

    def data
      @data ||= Parser.list
    end

    def area_name(mark="-")
      [
        province && province[:text],
        city && city[:text],
        district && district[:text] 
      ].compact.join(mark) 
    end

    def get_name
      get[:text]
    end

    def get
      @get ||= province? && province
      @get ||= city? && city
      @get ||= district? && district
      @get
    end

    def initialize(id)
      @id = id.to_s
    end

    def segment_blank?(segment)
      segment != "00"
    end

    def province
      @province ||=
      province_id && data && data[province_id]
    end

    def city
      city_id && province && province[:children][city_id]
    end

    def district
      district_id && city && city[:children][district_id]
    end

    def province?
      province_id && city_id.nil?
    end

    def city?
      province_id && city_id && district_id.nil?
    end

    def district?
      province_id && city_id && district_id
    end

    def province_id
      @province_id ||= 
        if id_match && segment_blank?(id_match[1])
          id_match[1].ljust(6, '0')
        end
    end

    def city_id 
      @city_id ||= 
        if id_match && segment_blank?(id_match[2])
          "#{id_match[1]}#{id_match[2]}".ljust(6, '0')
        end
    end

    def district_id
      @district_id ||= 
        if id_match && segment_blank?(id_match[3])
          id
        end
    end

    def id_match 
      @id_match ||= @id.match(self.class.id_regular)
    end

    class << self
      def id_regular
        /(\d{2})(\d{2})(\d{2})/ 
      end
    end
  end
end
