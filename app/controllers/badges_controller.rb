class BadgesController < ApplicationController
  def index
    @badge = Badge.new
  end

  def create
    require 'csv'
    badge_params = params.require(:badge).permit(PdfTemplate::DEFAULT_OPTIONS.keys + [:title])
    pdf_options  = {
        template:    badge_params[:template].presence || %Q[Hello <b>{{name}}</b>\n<br>\n<font size="48" name="Futura PT Cond">{{message}}</font>],
        data:        [{name: 'John', message: 'производство смыслов'}, {name: 'Mary', message: :hello}],
        page_layout: :landscape,
        paper_size:  'A5',
        font:        'PT Sans',
        margins:     [20, 40, 40, 40],
    }

    pdf_options.merge!(badge_params.as_json(except: [:background, :data, :title, :margins, :debug, :paper_size]).symbolize_keys)

    pdf_options[:paper_size] = badge_params[:paper_size] if badge_params[:paper_size].present?
    pdf_options[:background] = badge_params[:background].path if badge_params[:background].present?
    pdf_options[:debug] = '1' == badge_params[:debug] # check_box

    data = CSV.open(badge_params[:data].path, headers: true).map(&:to_h).as_json rescue nil
    pdf_options[:data] = data if data.present?
    pdf_options[:margins] = badge_params[:margins].split(/[, .-]+/).map(&:to_i) if badge_params[:margins].present?

    pdf = PdfTemplate.new(pdf_options)


    send_data pdf.to_pdf, disposition: :inline, filename: 'badges.pdf', type: 'application/pdf'
  end

  def show
  end
end
