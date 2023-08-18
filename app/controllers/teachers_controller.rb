require 'open-uri'

# docs :)
class TeachersController < ApplicationController
  def index
    teacher = current_teacher

    if teacher == {}
      head 404
    else
      render json: teacher
    end
  end

  private

  def parsed_table
    document = Nokogiri::HTML.parse(URI.parse('https://www.elisabethschule.de/schulgemeinde/kollegium/').open)
    document.css('table.contenttable tr:not(:first-child) td')
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def current_teacher
    table_data = parsed_table

    key = {
      name: 'name',
      abbreviation: 'abbreviation',
      subjects: 'subjects'
    }

    current_key = key[:name]

    current_teacher = {}

    table_data.each_with_index do |data, _index|
      if current_key == key[:name]
        current_teacher['name'] = data.text
        current_key = key[:abbreviation]

      elsif current_key == key[:abbreviation]
        current_teacher['abbreviation'] = data.text
        current_key = key[:subjects]

      elsif current_key == key[:subjects]
        current_teacher['subjects'] = data.text
        # teachers.append(current_teacher)

        if current_teacher['abbreviation'] == params[:abbreviation]
          # break and return the teacher
          break
        end

        current_teacher = {}
        current_key = key[:name]
      end
      # teachers.append(data.text)
    end

    current_teacher
  end
end
