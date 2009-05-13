#!/usr/bin/env ruby

# Please see attached LICENSE and README.markdown

require 'rubygems'
require 'activerecord'
require 'activesupport'
require 'activeresource'
require 'lighthouse'


# Configure Me... #####################################################

# Enter your Lighthouse account and token. The token must have both 
# read & write access.
Lighthouse.account = 'YOUR_ACCOUNT_NAME'
Lighthouse.token = 'YOUR_VERY_LONG_API_TOKEN'

# Your Lighthouse Project ID
PROJECT_ID = 12345

# A mapping of your Trac usernames to Lighthouse user ID's
USERS = { 'someone' => 12345, 
             'someone_else' => 23456 }

# A mapping of your Trac Milestones to Lighthouse milestone ID's
MILESTONES = { '1.0' => 1234,
               '1.1' => 2345,
               'Beta' => 3456 }
                
# Map your Trac state strings to Lighthouse state strings
STATES = { 'assigned' => 'open',
           'fixed' => 'resolved',
           'duplicate' => 'invalid',
           'wontfix' => 'invalid',
           'invalid' => 'invalid',
           'new' => 'new',
           'closed' => 'resolved',
           'worksforme' => 'invalid',
           'reopened' => 'open' } 

# End of configuration... #############################################

class ActiveRecord::Base
  def format_trac_text(text)
    text.gsub(/([{}])\1{2}/, '@@@')
  end
end


class TracMilestone < ActiveRecord::Base
  set_table_name 'milestone'
  set_primary_key :name

  def save_to_lighthouse
    Lighthouse::Milestone.new(:title => name, :goals => description, :project_id => PROJECT_ID, :due_on => Time.at(due))
  end
end

class TracChange < ActiveRecord::Base
  set_table_name 'ticket_change'

  def to_s
    "\n*#{author}* commented at #{Time.at(time).strftime('%c')}:\n\n#{format_trac_text(newvalue)}"   
  end
  
end

class TracTicket < ActiveRecord::Base
  set_table_name 'ticket'

  # only comments
  has_many :comments, :class_name => 'TracChange', :foreign_key => 'ticket', :conditions => "field = 'comment' AND newvalue != ''", :order => 'time ASC'

  # type column is used by trac
  def self.inheritance_column
    nil
  end

  def category
    attributes['type']
  end

  def save_to_lighthouse
    t = Lighthouse::Ticket.new(:project_id => PROJECT_ID, 
                           :title => summary,  
                           :body => format_trac_text(description),  
                           :assigned_user_id => USERS[owner],  
                           :state => STATES[resolution || status],  
                           :milestone_id => MILESTONES[milestone] )
    t.tags << taggify(component) unless component.nil?
    t.tags << taggify(priority) unless priority.nil?
    t.save
    comments.each { |c|
	    t.body = format_trac_text(c.newvalue)
	    t.save
    }
    t
  end

  def save_comments_to_lighthouse
  end

  def formatted_comments
    returning "h3. Trac Comments\n\n" do |txt| 
      txt<<comments.each{|c| c.to_s}.join("") 
    end
  end

  def taggify(s)
    s.downcase.gsub(/ /,'_').gsub(/[^a-z0-9\-_@\!']/,'').strip
  end

end

def convert(trac_db, opts=nil)
  ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => trac_db)
  opts ||= { :order => ('id ASC')}
  TracTicket.find(:all, opts).each{|t| t.save_to_lighthouse; true}
end


unless ARGV.length > 0
  puts "No trac sqlite database file specified."
  Process.exit(1)
else
  convert(ARGV[0])
end
