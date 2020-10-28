class Henriette::Converter::Int8Converter
  def self.from_rs(result_set : DB::ResultSet) : Int8
    result_set.read(Int64).to_i8
  end
end
