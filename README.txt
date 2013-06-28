= PdfLabels

* by Rob Kaufman - http://www.lightning-tree.net
* http://rubyforge.org/projects/pdf-labels/

== DESCRIPTION:

Welcome to the PDF-Labels project.  Our aim is to make creating labels
programmatically easy in Ruby.  This Library builds on top of
"PDF::Writer":http://ruby-pdf.rubyforge.org/ and uses the templates
from "gLabels":http://glabels.sourceforge.org.  What this means is
easy, clean Ruby code to create many common label types without
measuring the labels yourself!  All of this in pure Ruby (we use the
XML templates from gLabels, we do NOT have a dependancy on gLabels,
nor on Gnome)

== FEATURES/PROBLEMS:

* Works with all gLabels supported templates for rectangular labels
* Does not yet work for CD labels (circles)

== SYNOPSIS:
    p = PDFLabelPage.new("Avery  8160") # label is 2 x 10
    #Some examples of adding labels
    p = Pdf::Label::Batch.new("Avery 8160") # label is 2 x 10
    p.add_label("&*\%Positoin 15", position: 15) # should add col 2, row 1
    #does the use_margin = true work?
    p.add_label('With Margin', use_margin: true, position: 4)
    #with out the margin?
    p.add_label('No Margin', position: 5, use_margin: false)
    p.add_label('This is the song that never ends, yes it goes on and on my friends', position: 7 )
    p.add_label('X Offset = 4, Y Offset = -6', position: 9,  offset_x: 4, offset_y: -6)
    p.add_label('Centered', position: 26, justification: :center) # should add col 2, row 15
    p.add_label('[Right justified]', justification: :right, position: 28)# col 2, row 14, right justified.
    p.add_label('col 2 row 15', position: 29) # should add col 2, row 15
    p.add_label('This was added first and has a BIG font', position: 8,  font_size: 16)
    p.add_label('This was added last and has a small font', position: 8, font_size: 8, offset_y: -40)
    p.draw_boxes(false, true)
    #TODO Anybody out there think of a better way to test this?
    p.save_as("label_output.pdf")

  or you could add multiline labels!

    pdf = Pdf::Label::Batch.new('Avery 8160')
    pdf.draw_boxes(false, false)

    contents = [];
    contents << {text: 'This',  justification: :center, font_size: 8, font_type: 'Courier'}
    contents << {text: 'Is a', justification: :right, font_size: 8, font_type: 'Helvetica-BoldOblique'}
    contents << {text: 'Test', font_type: 'Times-Roman'}

    5.times do |i|
      pdf.add_multiline_label(contents,i)
    end
    pdf.save_as("multiline_label_output.pdf")

== REQUIREMENTS:

Currently there are no external dependencies, though a version of xml-mapping and pdf-writer (and its dependencies) are provided in vendor

== INSTALL:

sudo gem install pdf-labels

== LICENSE:

(The MIT License)

Copyright (c) 2007 Rob Kaufman

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
