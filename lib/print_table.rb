# Handles output formatting
module PrintTable
  require 'terminal-table'

  def self.tableize(matched_item, title)
    table_rows = format_as_rows(matched_item)
    draw_table(table_rows, title)
  end

  def self.format_as_rows(matched_item)
    if matched_item.class.name == 'Array'
      matched_item.map { |entry|  [entry] }
    elsif matched_item.class.name == 'Hash'
      matched_item.map { |k, v| [k, v] }
    end
  end

  def self.draw_table(rows, title)
    Terminal::Table.new rows: rows,
                        style: {  all_separators: true,
                                  border_x: '=',
                                  border_i: 'x',
                                  padding_left: 3 },
                        title: title.capitalize
  end
end
