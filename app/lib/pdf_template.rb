require 'prawn'
require 'prawn/measurement_extensions'
require 'combine_pdf'
require 'mustache'

###
#
# Example:
#
# pdf = PdfTemplate.new(
#     template: 'this is it <b>{{a}}</b><br><font size="48" name="Futura PT Cond">{{b}}</font>',
#     data: [{a: 'dd', b: 'производство смыслов'},{a: 'my  text', b: :hello}],
#     page_layout: :landscape,
#     paper_size: 'A5',
#     font: 'Urania',
#     margins: [20, 40, 40 ,40],
#     background: './male.png',
# )
# File.binwrite('./test.pdf', pdf.to_pdf)
#
# Template eats `Mustache`-compliant tags and supports inline formatting
# All default options can be rewritten via arguments
#
# `data` option should be supplied for template generation. This can be a hash or an array of hashes
#
# `background` can be either image or another pdf file
#
class PdfTemplate < Prawn::Document

  DEFAULT_TEMPLATE = '<b>{{name}}</b>'

  FONTS_PATH = Rails.root.join('lib/fonts/')
  DEFAULT_FONTS = {

      'Arial'               => {
          normal: File.join(FONTS_PATH, 'arial.ttf'),
          bold:   File.join(FONTS_PATH, 'arial_bold.ttf')
      },
      'Cooper'     => {
          normal:      File.join(FONTS_PATH, 'COOPER.TTF'),
          bold:        File.join(FONTS_PATH, 'CooperBlackStd.ttf'),
          italic:      File.join(FONTS_PATH, 'CooperBlackStd-Italic.ttf'),
      },
      'PF Handbook Pro'     => {
          normal:      File.join(FONTS_PATH, 'PFHandbookPro-Regular.ttf'),
          bold:        File.join(FONTS_PATH, 'PFHandbookPro-Bold.ttf'),
          italic:      File.join(FONTS_PATH, 'PFHandbookPro-Italic.ttf'),
          bold_italic: File.join(FONTS_PATH, 'PFHandbookPro-BoldItalic.ttf')
      },
      'PT Sans'             => {
          normal: File.join(FONTS_PATH, 'PTS55F.ttf'),
          bold:   File.join(FONTS_PATH, 'PTS75F.ttf'),
      },
      'PT Sans Narrow'      => {
          normal: File.join(FONTS_PATH, 'PTN57F.ttf'),
          bold:   File.join(FONTS_PATH, 'PTN77F.ttf'),
      },
      'Fontin Sans CR'      => {
          normal:      File.join(FONTS_PATH, 'FontinSans_Cyrillic_R_46b.ttf'),
          bold:        File.join(FONTS_PATH, 'FontinSans_Cyrillic_B_46b.ttf'),
          italic:      File.join(FONTS_PATH, 'FontinSans_Cyrillic_I_46b.ttf'),
          bold_italic: File.join(FONTS_PATH, 'FontinSans_Cyrillic_BI_46b.ttf')
      },
      'Futura PT Cond'      => {
          normal: File.join(FONTS_PATH, 'FUTURAPTCOND-MEDIUM.ttf'),
          bold:   File.join(FONTS_PATH, 'FUTURAPTCOND-BOLD.ttf'),
      },
      'Segoe UI'            => {
          normal: File.join(FONTS_PATH, 'seguibk.ttf'),
          bold:   File.join(FONTS_PATH, 'seguibd.ttf'),
      },
      'Urania'              => {
          normal:      File.join(FONTS_PATH, 'URANIA CZECH.ttf'),
          bold:        File.join(FONTS_PATH, 'URANIA CZECH.ttf'),
          italic:      File.join(FONTS_PATH, 'URANIA CZECH.ttf'),
          bold_italic: File.join(FONTS_PATH, 'URANIA CZECH.ttf'),
      },
      'TravelingTypewriter' => {
          normal:      File.join(FONTS_PATH, 'TravelingTypewriter.ttf'),
          bold:        File.join(FONTS_PATH, 'TravelingTypewriter.ttf'),
          italic:      File.join(FONTS_PATH, 'TravelingTypewriter.ttf'),
          bold_italic: File.join(FONTS_PATH, 'TravelingTypewriter.ttf'),
      },
  }

  DEFAULT_OPTIONS = {
      font:  'Arial',
      margins:  [10, 10, 10, 10],
      paper_size:  'A4', # or as an array: [210.mm, 297.mm],
      page_layout: :portrait,
      template:  DEFAULT_TEMPLATE,
      fonts:  DEFAULT_FONTS,
      font_size: 16,
      text_align: 'center',
      valigh: 'top',
      use_background: false,
      leading: 1,
      background: nil,
      data: {name: 'John Snow'},
      debug: false,
  }

  attr_accessor :data
  def initialize(options = {})
    @options = DEFAULT_OPTIONS.merge(options)
    @data = @options.delete(:data)

    pdf_params = {
        page_size: @options[:paper_size],
        page_layout: @options[:page_layout].to_sym,
        margin: @options[:margins].map(&:mm)
    }
    if !@options[:background].nil? && File.exists?(@options[:background])
      case File.extname(@options[:background])
      when '.png', '.jpg', 'jpeg'
        pdf_params = pdf_params.merge background: @options[:background]
      when '.pdf'
        @template_page   = CombinePDF.load(@options[:background], allow_optional_content: true).pages[0]
      end
    end
    super pdf_params

    font_families.update(@options[:fonts])
    font @options[:font]
    default_leading @options[:leading]

    stroke_axis if @options[:debug]

    @template = Mustache.new
    @template.template = @options[:template]

    generate_pdf

  end


  def to_pdf
    if @template_page.nil?
      render
    else
      self_pdf = CombinePDF.parse(render)
      combined_pdf    = CombinePDF.new
      self_pdf.pages.each do |page|
        combined_pdf << (@template_page.clone << page)
      end
      combined_pdf.to_pdf
    end
  end

  private

  def generate_pdf
    if @data.is_a?(Array)
      @data.each do |item|
        start_new_page unless item == @data.first
        generate_page(item)
      end
    else
      generate_page(@data)
    end
  end

  def generate_page(text_string)
    text @template.render(text_string), size: @options[:font_size], inline_format: true, align: @options[:text_align].to_sym
  end
end

