class Badge
  include ActiveModel::Model
  attr_accessor :background, :data, :template,
                :paper_size, :page_layout, :margins,
                :font, :font_size, :text_align, :leading, :debug

  DEFAULT_OPTIONS = {
      template:    %Q[Hello <b>{{name}}</b>\n<br>\n<font size="48" name="Futura PT Cond">{{message}}</font>],
      data:        [{name: 'John', message: 'производство смыслов'}, {name: 'Mary', message: :hello}],
      page_layout: :landscape,
      paper_size:  'A5',
      font:        'PT Sans',
      margins:     [20, 40, 40, 40],
  }

  def initialize(options = {})
    options = options.reverse_merge(DEFAULT_OPTIONS)
    assign_attributes(options)
  end

  def to_pdf
    pdf = PdfTemplate.new(as_json)
    pdf.to_pdf
  end
end