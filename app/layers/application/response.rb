module Application
  class Response < OpenStruct
    def include?(key)
      self.each_pair.map(&:first).include?(key)
    end
  end
end
