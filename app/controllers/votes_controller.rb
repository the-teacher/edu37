class VotesController < ApplicationController
  before_filter :prepare_vote_params, :only=>[:up, :down]
  
  def up
    # vote from this machine doesnt exist - first vote right now!
    unless @last_vote
      create_up_vote_for(@object)
      render(:action=>:vote, :layout => false) and return
    end

    # vote from this machine exist - vote with delay
    if @last_vote
      if @last_vote.created_at < @voting_delay.minutes.ago
        create_up_vote_for(@object)
        render(:action=>:vote, :layout => false) and return
      else
        delay_time = (Vote.last.created_at + @voting_delay.minutes)-Time.now
        @minutes = delay_time.to_i/1.minute
        @seconds = delay_time.to_i - @minutes*60
        render(:action=>:wait, :layout => false) and return
      end
    end

  end#up

  def down
    # vote from this machine doesnt exist - first vote right now!
    unless @last_vote
      create_down_vote_for(@object)
      render(:action=>:vote, :layout => false) and return
    end

    # vote from this machine exist - vote with delay
    if @last_vote
      if @last_vote.created_at < @voting_delay.minutes.ago
        create_down_vote_for(@object)
        render(:action=>:vote, :layout => false) and return
      else
        delay_time = (Vote.last.created_at + @voting_delay.minutes)-Time.now
        @minutes = delay_time.to_i/1.minute
        @seconds = delay_time.to_i - @minutes*60
        render(:action=>:wait, :layout => false) and return
      end
    end

  end#down

  protected
  
  def prepare_vote_params
    # ERROR: unregistered object type
    render  :text =>"alert('Undefined type of voitable object')" and return unless ['page', 'publication', 'forum', 'topic'].include? params[:object_type]

    # ERROR: object not found
    @object= params[:object_type].camelize.constantize.find_by_zip(params[:object_id])
    render  :text =>"alert('Undefined commentable object')" and return unless @object

    # config/initializers/project.rb
    @voting_delay= Project::VOTING_DELAY

    # Vote from this machine exists? => @last_vote
    find_last_vote
  end

  # Find last vote for this object by view_token or ip/remote_ip
  def find_last_vote
    # config/initializers/project.rb
    view_token= cookies[Project::VIEW_TOKEN]
    
    @last_vote= Vote.where(["object_type = :type AND object_id = :id", {:type=>params[:object_type], :id=>@object.id}]).scoping do      
      if view_token
        Vote.where(:view_token=>view_token).scoping{ Vote.last }
      else
        Vote.where([ "ip IN (:ip_set) OR remote_ip IN (:ip_set)", {:ip_set=>[request.ip,request.remote_ip].uniq} ]).scoping{ Vote.last }
      end
    end
  end

  def create_up_vote_for(object)
    vote= object.votes.new.init(:value=>2, :user=>current_user, :request=>request, :cookies=>cookies)   if     logged_in?
    vote= object.votes.new.init(:value=>1, :request=>request, :cookies=>cookies)                        unless logged_in?
    vote.save
    @audited_object = vote
    object.reload
  end

  def create_down_vote_for(object)
    vote= object.votes.new.init(:value=>-2, :user=>current_user, :request=>request, :cookies=>cookies)  if     logged_in?
    vote= object.votes.new.init(:value=>-1, :request=>request, :cookies=>cookies)                       unless logged_in?
    vote.save
    @audited_object = vote
    object.reload
  end
end
