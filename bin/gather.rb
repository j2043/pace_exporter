#!/usr/bin/env ruby

require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
require 'pp'
require 'sinatra'

require_relative '../lib/pace'

class PacePresenter < Sinatra::Base

  before do
    content_type 'text/plain'
  end

  get '/metrics' do
    Pace.new.gather.join
  end

end

PacePresenter.start!
