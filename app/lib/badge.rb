class Badge
  include ActiveModel::Model

  attr_accessor :background, :data, :template,
                :paper_size, :page_layout, :margins,
                :font, :font_size, :text_align, :valign, :leading, :debug

  DEFAULT_OPTIONS = {
      template:    %Q[Hello <b>{{name}}</b>\n<br>\n<font size="48" name="Futura PT Cond">{{message}}</font>],
      data:        [{name: 'John', message: 'производство смыслов'}, {name: 'Mary', message: :hello}],
      page_layout: :landscape,
      paper_size:  'A5',
      font:        'PT Sans',
      margins:     [20, 40, 40, 40],
      text_align:  'left',
      valign:      'top',
  }

  validates_presence_of :template, :data, :page_layout, :paper_size, :font, :margins
  validates_inclusion_of :paper_size, in: PDF::Core::PageGeometry::SIZES.keys
  validates_inclusion_of :font, in: PdfTemplate::DEFAULT_FONTS.keys
  validates_inclusion_of :page_layout, in: %i(portrait landscape)
  validates_numericality_of :font_size, allow_nil: true
  validates_inclusion_of :text_align, in: %w(left right center justify)
  validates_inclusion_of :valign, in: %w(top center bottom)

  def initialize(options = {})
    options[:page_layout] = options[:page_layout].to_sym if options[:page_layout].present?
    assign_attributes(DEFAULT_OPTIONS.merge(options))
  end

  def to_pdf
    pdf = PdfTemplate.new(as_json.symbolize_keys)
    pdf.to_pdf
  end

end