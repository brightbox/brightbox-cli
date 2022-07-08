require "hirb"

module Brightbox
  # Hack to set ascii art table cell width due to limitations in Hirb
  class Hirb::Helpers::Table
    remove_const :BORDER_LENGTH
    BORDER_LENGTH = 2
  end

  # Remove most of the ascii art table output
  class SimpleTable < Hirb::Helpers::Table
    def render_table_header
      title_row = " " + @fields.map do |f|
        format_cell(@headers[f], @field_lengths[f])
      end.join("  ")
      ["", title_row, render_border]
    end

    def render_footer
      [render_border, ""]
    end

    def render_border
      "-" + @fields.map { |f| "-" * @field_lengths[f] }.join("--") + "-"
    end

    def render_rows
      @rows.map do |row|
        row = " " + @fields.map do |f|
          format_cell(row[f], @field_lengths[f])
        end.join("  ")
      end
    end

    def enforce_field_constraints
      max_fields.each do |k, max|
        @field_lengths[k] = max if @field_lengths[k].to_i > max
      end
      # Never shrink the id field
      @field_lengths[:id] = IDENTIFIER_SIZE if @field_lengths[:id]
    end
  end

  # Vertical table for "show" views
  class ShowTable < Hirb::Helpers::Table
    def self.render(rows, options = {})
      new(rows, { :escape_special_chars => false, :resize => false }.merge(options)).render
    end

    def setup_field_lengths
      @field_lengths = default_field_lengths
    end

    def render_header; []; end

    def render_footer; []; end

    def render_rows
      longest_header = Hirb::String.size(@headers.values.max_by { |e| Hirb::String.size(e) })
      @rows.map do |row|
        fields = @fields.map do |f|
          "#{Hirb::String.rjust(@headers[f], longest_header)}: #{row[f]}"
        end
        fields << "" if @rows.size > 1
        fields.compact.join("\n")
      end
    end
  end

  # Print nice ascii tables (or tab separated lists, depending on mode)
  # Has lots of magic.
  def render_table(rows, options = {})
    options = { :description => false }.merge options
    # Figure out the fields from the :model option
    if options[:model] && options[:fields].nil?
      options[:fields] = options[:model].default_field_order
    end
    # Figure out the fields from the first row
    if options[:fields].nil? && rows.first.class.respond_to?(:default_field_order)
      options[:fields] = rows.first.class.default_field_order
    end
    # Call to_row on all the rows
    rows = rows.map do |row|
      row.respond_to?(:to_row) ? row.to_row : row
    end
    # Call render_cell on all the cells
    rows.each do |row|
      # FIXME: default Api subclasses do not respond to #keys so specialising
      #   #to_row is required to not break the following
      row.each_key do |k|
        row[k] = row[k].render_cell if row[k].respond_to? :render_cell
      end
    end
    if options[:s]
      # Simple output
      rows.each do |row|
        if options[:vertical]
          data options[:fields].map { |k| [k, row[k]].join("\t") }.join("\n")
        else
          data options[:fields].map { |k| row[k].is_a?(Array) ? row[k].join(",") : row[k] }.join("\t")
        end
      end
    elsif options[:vertical]
      # "graphical" table
      data ShowTable.render(rows, options)
    else
      data SimpleTable.render(rows, options)
    end
  end

  module_function :render_table
end
