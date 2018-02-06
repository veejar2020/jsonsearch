# This defines the search logic implementation
class SearchJson
  require 'json'
  require 'set'
  require 'print_table'
  attr_accessor :file_name, :obj_list, :field, :value

  DATA_DIR = File.join(File.dirname(File.expand_path('.', __dir__)),
                       'lib', 'data', '*')

  FILES = Dir.glob(DATA_DIR).map do |file_path|
    File.basename(file_path, '.json')
  end

  def initialize(file, field = nil, value = nil)
    @file_name = File.basename(file, '.json')
    @obj_list = JSON.parse(File.read(file))
    @field = field
    @value = value
  end

  def perform_search
    filter_obj_list
    obj_list.map do |result_item|
      PrintTable.tableize(result_item, file_name)
    end
  end

  def perform_list
    PrintTable.tableize(uniq_fields, file_name)
  end

  # filter list over each pair of field - value
  def filter_obj_list
    field.each_with_index do |search_field, index|
      filter_items(search_field, value[index])
    end
    return unless obj_list.empty?
    message = "Cannot find field(s) #{field.join(',')} "\
      "with value(s) #{value.join(',')} in #{file_name}"
    obj_list << [message]
  end

  # filter hash list by matching key value
  def filter_items(key, value)
    value = value.to_s # to convert nil to ""
    obj_list.reject! do |obj|
      if obj[key].class.name == 'Array'
        !obj[key].map(&:to_s).include?(value)
      else
        obj[key].to_s != value
      end
    end
  end

  def uniq_fields
    all_fields = obj_list.map(&:keys).flatten
    Set.new(all_fields).to_a
  end

  def validate_field(input_fields)
    input_fields.all? do |input_field|
      uniq_fields.include?(input_field)
    end
  end
end
