require 'open-uri'

class TeachersController < ApplicationController
  def index
    url = URI.parse('https://www.elisabethschule.de/schulgemeinde/kollegium/')
    document = Nokogiri::HTML.parse(URI.open(url))
    table_data = document.css("table.contenttable tr:not(:first-child) td")
    # teachers = []

    key = {
      :name => 'name',
      :abbreviation => 'abbreviation',
      :subjects => 'subjects'
    }

    current_key = key[:name]

    current_teacher = {}

    table_data.each_with_index do |data, index|

      if current_key === key[:name]
        current_teacher['name'] = data.text
        current_key = key[:abbreviation]

      elsif current_key === key[:abbreviation]
        current_teacher['abbreviation'] = data.text
        current_key = key[:subjects]

      elsif current_key === key[:subjects]
        current_teacher['subjects'] = data.text
        # teachers.append(current_teacher)

        if current_teacher['abbreviation'] === params[:abbreviation]
          # break and return the teacher
          break
        end

        current_teacher = {}
        current_key = key[:name]
      end
      # teachers.append(data.text)
    end

    if current_teacher === {}
      head 404
    else
      render json: current_teacher
    end
  end
end
