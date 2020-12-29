require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    uri = URI.open(index_url)

    students = Nokogiri::HTML(uri).css('.student-card')
    student_hashes = []

    students.each do |card|
      student_hash = {
        :name => name = card.css('.student-name').text,
        :location => card.css('.student-location').text,
        :profile_url => card.css('a').first.attr('href')
      } 
      student_hashes << student_hash
    end
    student_hashes
  end

  def self.scrape_profile_page(profile_url)
    uri = URI.open(profile_url)

    profile = Nokogiri::HTML(uri)
    social_items = profile.css(".social-icon-container a")
    student_hash = {}

    social_items.each do |item|
      if item.attr('href').match(/twitter/) != nil
        student_hash[:twitter] = item.attr('href')
      elsif item.attr('href').match(/linkedin/) != nil
        student_hash[:linkedin] = item.attr('href')
      elsif item.attr('href').match(/github/) != nil
        student_hash[:github] = item.attr('href')
      else
        student_hash[:blog] = item.attr('href')
      end
    end
    
    student_hash[:profile_quote] = profile.css('.profile-quote').text
    student_hash[:bio] = profile.css('.description-holder p').text
    student_hash
  end
end