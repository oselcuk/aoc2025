
class Array
  def split_at(element)
    slice_before(element)
      .map{|arr| arr.first == element ? arr.drop(1) : arr}
      .reject(&:empty?)
  end
end