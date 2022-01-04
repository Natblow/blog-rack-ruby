#!/usr/bin/env ruby
require 'rack'
load 'visit_counter.rb'
load 'app.rb'

use VisitCounter
run App.new
