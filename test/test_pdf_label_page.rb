$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'test/unit'
require '/Users/gagoar/workspace/PDF-Labels/lib/pdf/label'
require 'pry'
require 'pry-nav'

class TestPdfLabelBatch < Test::Unit::TestCase
  ROOT = File.expand_path(File.dirname(__FILE__) + "/../")
  def setup
  end

  def test_new_with_tempalte_name
    p = Pdf::Label::Batch.new("Avery 5366")
    assert p
    assert_equal p.template.name, "Avery 5366"
  end

  def test_new_with_alias_name
    p = Pdf::Label::Batch.new("Avery 8166")
    assert p
    assert_equal p.template.name, "Avery 5366"
  end

  def test_new_with_paper_type
    p = Pdf::Label::Batch.new("Avery 5366", {paper: 'Legal'})
    assert p
    assert_equal p.pdf.page_width, 612.0
    assert_equal p.pdf.page_height, 1008.0
  end

  def test_new_with_tempalte_not_found
    assert_raise(RuntimeError) {
      p = Pdf::Label::Batch.new('Some Non-Existing')
    }
  end

  #TODO other options are possible for pdf_options, we need to test those at some point

  def test_PdfLabelBatch_load_tempalte_set
    Pdf::Label::Batch.load_template_set("#{ROOT}/templates/avery-iso-templates.xml")
     #Avery 7160 is found in avery-iso-templates
     p = Pdf::Label::Batch.new("Avery 7160")
     assert p
     assert_equal p.pdf.page_width, 595.28
     assert_equal p.pdf.page_height, 841.89
     Pdf::Label::Batch.load_template_set("#{ROOT}/templates/avery-us-templates.xml")
   end

   def test_PdfLabelBatch_all_template_names
     #what happens if we havn't loaded a template yet?
     t = Pdf::Label::Batch.all_template_names
     assert t
     assert_equal t.class, Array
     assert_equal t.count, 292
     assert_equal t.first, "Avery 5160"
   end

  def test_add_label_3_by_10
    p = Pdf::Label::Batch.new("Avery 8160") # label is 2 x 10
    p.add_label("Positoin 15", position: 15) # should add col 2, row 1
    #does the use_margin = true work?
    p.add_label('With Margin', use_margin: true, position: 4)
    #with out the margin?
    p.add_label('No Margin', position: 5, use_margin: false)
    p.add_label('This is the song that never ends, yes it goes on and on my friends', position: 7 )
    p.add_label('X Offset = 4, Y Offset = -6', position: 9,  offset_x: 4, offset_y: -6)
    p.add_label('Centered', position: 26, justification: :center) # should add col 2, row 15
    p.add_label('[Right justified]', justification: :right, position: 28)# col 2, row 14, right justified.
    p.add_label('col 2 row 15', position: 29) # should add col 2, row 15
    p.add_label('This was added last and has a BIG font', position: 8,  font_size: 16)
    p.add_label('This was added last and has a small font', position: 8, font_size: 8, offset_y: -40)
    p.draw_boxes(false, true)
    #TODO Anybody out there think of a better way to test this?
    p.save_as("#{ROOT}/test_add_label_output.pdf")
  end

  def test_add_label_3_by_10_multi_page
    p = Pdf::Label::Batch.new("Avery 8160") # label is 2 x 10
    p.draw_boxes(false, true)
    p.add_label('Position 15', position: 15) # should add col 2, row 1
    #does the use_margin = true work?
    p.add_label('using margin', use_margin: true, position: 4)
    #with out the margin?
    p.add_label('No Margin', position: 5, use_margin: false)
    p.add_label('This should be on a new page', position: 48)
    p.add_label('This should be first a page 2', position: 30)
    #TODO Anybody out there think of a better way to test this?
    p.save_as("#{ROOT}/test_add_multi_page.pdf")
  end

  def test_multipage_2
    p = Pdf::Label::Batch.new("Avery 8160") # label is 2 x 10
    p.draw_boxes(false, true)
    100.times do |i|
      p.add_label("Position #{i}", position: i) # should add col 1, row 2
    end
    p.save_as("#{ROOT}/test_add_multi_page2.pdf")
  end

  def test_add_many_labels
    p = Pdf::Label::Batch.new("Avery 8160") # label is 2 x 10
    #without positoin, so start at 1
    p.add_many_labels('Hello Five Times!', count: 5)
    p.add_many_labels('Hellow four more times, starting at 15', count: 4, position: 15)
    p.save_as("#{ROOT}/test_add_many_label_output.pdf")
  end

  def test_draw_boxes
    p = Pdf::Label::Batch.new("Avery 5366") # label is 2 x 10
    p.draw_boxes
    p.save_as("#{ROOT}/test_draw_boxes_output.pdf")
  end

  def test_font_path
    font_path = "#{ROOT}/fonts"
    assert PDF::Writer::FontMetrics::METRICS_PATH.include?(font_path)
    assert PDF::Writer::FONT_PATH.include?(font_path)
  end

  def test_set_and_get_barcode_font
    p = Pdf::Label::Batch.new("Avery 8160") # label is 2 x 10
    assert_equal "Code3de9.afm", p.barcode_font

    assert p.barcode_font = "CodeDatamatrix.afm"
    assert_equal "CodeDatamatrix.afm", p.barcode_font

    assert_raise(RuntimeError) do
      p.barcode_font = "CodeBob"
    end
    assert_equal "CodeDatamatrix.afm", p.barcode_font

  end

  def test_add_barcode_label
    p = Pdf::Label::Batch.new("Avery 8160") # label is 2 x 2
    i = 0
    Pdf::Label::Batch.all_barcode_fonts.keys.each_with_index do |font_name, i|
      p.barcode_font = font_name
      p.add_label(font_name.to_s, position: i)
      p.add_barcode_label(bar_text: "Hello", bar_size: 32, text: "HELLO", position: i)
    end
    p.save_as("#{ROOT}/test_barcode_output.pdf")
  end

  def test_code39
    p = Pdf::Label::Batch.new("Avery 8160") # label is 2 x 2
    assert_equal "*HELLO123*", p.code39("hellO123")
  end

  def test_label_information
    templates = Pdf::Label::Batch.all_templates
    assert templates.size > 0
    t = templates.first
    assert_equal 'Avery 5160', t.name
    assert_equal 3, t.nx
    assert_equal 10, t.ny
    assert_equal 'US-Letter', t.size
    assert_equal 'Address Labels', t.find_description
  end

  def test_label_information_no_crash
    Pdf::Label::Batch.all_templates.each do |t|
      t.nx
      t.ny
      t.find_description
    end
  end
end
