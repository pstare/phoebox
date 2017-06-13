#!/usr/bin/env ruby

RgbColor = Struct.new(
  :red,
  :green,
  :blue
)

Elements = Struct.new(
  :header,
  :num,
  :color,
  :type,
  :footer
)

class Phoebox
  REGEX = /^(?<header>.*<POSITION_MARK .* )Num="(?<num>[^"]+)" .*Red="(?<red>\d+)" Green="(?<green>\d+)" Blue="(?<blue>\d+)"(?<footer>><\/POSITION_MARK>)$/

  attr_reader :source_file, :target_file

  def initialize(source, target)
    @source_file = source
    @target_file = target

    fail ArgumentError, "File couldn't be opened" unless input.is_a? Array
  end

  def input
    @input ||= File.readlines(source_file)
  end

  def output
    @output ||= File.open(target_file, "w")
  end

  def regex
    REGEX
  end
  
  def palette
    @palette ||= {
      red: RgbColor.new(230, 40, 40),
      green: RgbColor.new(60, 235, 80),
      gold: RgbColor.new(255, 140, 0),
      blue: RgbColor.new(48, 90, 255),
      fuchsia: RgbColor.new(255, 18, 123),
      paleyellow: RgbColor.new(180, 190, 4),
      purple: RgbColor.new(180, 50, 255),
      pink: RgbColor.new(222, 68, 207)
    }
  end

  def desired_color_for
    @desired_color_for ||= {
      grid:    palette[:red],
      regular: palette[:green],
      load:    palette[:blue],
      mix:     palette[:pink],
      loop:    palette[:gold]
    }
  end

  def cue_type_from(color)
    decomposed_color = [color.red, color.green, color.blue]

    traktor_color_mappings[decomposed_color]
  end

  def traktor_color_mappings
    @traktor_color_mappings ||= {
      [230, 40, 40]  => :grid,
      [0, 224, 255]  => :regular,
      [180, 190, 4]  => :load,
      [224, 100, 27] => :mix,
      [16, 177, 118] => :loop
    }
  end

  def converted_color_from(original_color)
    cue_type = cue_type_from(original_color)
    return original_color unless cue_type

    desired_color_for[cue_type]
  end

  def elements_from(match)
    original        = RgbColor.new(match[:red].to_i, match[:green].to_i, match[:blue].to_i)

    elements        = Elements.new
    elements.num    = match[:num]
    elements.header = match[:header]
    elements.footer = match[:footer]
    elements.color  = converted_color_from(original)
    elements.type   = cue_type_from(elements.color)

    elements
  end

  def color_substring_from(color)
    %Q(Red="#{color.red}" Green="#{color.green}" Blue="#{color.blue}")
  end

  def converted_cue_from(e, type:)
    e.num = -1 unless type == :hotcue
    %Q(#{e.header}Num="#{e.num}" #{color_substring_from(e.color)}#{e.footer})
  end

  def write_and_convert(line)
    if matched_line = regex.match(line)
      elements = elements_from(matched_line)
      output.puts converted_cue_from(elements, type: :hotcue)
      output.puts converted_cue_from(elements, type: :memory) unless elements.type == :grid
    else
      output.puts line
    end
  end

  def translate
    input.each { |line| write_and_convert(line) }
  end
end

source_file = "input.xml"
target_file = "output.xml"

ph = Phoebox.new(source_file, target_file)
ph.translate
