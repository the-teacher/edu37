class TopicsController < ApplicationController
  before_filter :find_topic,      :only=>[:show, :edit, :update, :destroy]
  before_filter :get_topic_state, :only=> [:update]

  before_filter :find_comments, :only=>[:show, :edit]
  before_filter :new_comment,   :only=>[:show, :edit]

  def index
    @topics = @user.topics.for_index.all(:order=>"lft ASC")
  end

  def show
    @topic.increment!(:show_count)
    @forum= @topic.forum
  end

  def edit
    @forum= @topic.forum
    @comments= @topic.comments
  end

  def new
    @forum = @user.forums.find_by_zip(params[:forum])
    @topic= @user.topics.new
    @topic.forum_zip = @forum.zip
  end

  def create
    @forum = @user.forums.find_by_zip(params[:topic][:forum_zip])
    @topic = @forum.topics.new(params[:topic]).init(:user=>@user, :creator=>current_user)
    if @topic.save
      @topic.to_draft if current_user.owner?(@topic)
      redirect_to(edit_topic_url(@topic, :subdomain=>@user.subdomain), :notice => 'Тема успешно создана')
    else
      render :action => "new"
    end
  end

  def update
    if @topic.update_attributes(params[:topic])
      set_topic_state
      redirect_to(edit_topic_url(@topic, :subdomain=>@user.subdomain), :notice => 'Тема успешно обновлена')
    else
      render :action => "edit"
    end
  end

  def destroy
    @topic.to_deleted
    redirect_to forums_url(:subdomain=>@user.subdomain)
  end

  protected

  def find_topic
    if action_name == 'restructure'
      @topic= @user.topics.find(params[:id].to_i)
    elsif action_name == 'show'
      zip= params[:id].split('---').first
      @topic= @user.topics.find_by_zip(zip)
    else
      @topic= @user.topics.find_by_zip(params[:id])
    end

    access_denied and return unless @topic
    @audited_object=          @topic # audition system
    @object_for_role_system=  @topic # role system
  end

  def get_topic_state
    if current_user.has_role?(:system, :administrator) || current_user.has_role?(:topics, :moderator)
      @moderation_state = :to_blocked_moderation  if params[:to_blocked_moderation]
      @moderation_state = :to_unsafe_moderation   if params[:to_unsafe_moderation]
      @moderation_state = :to_safe_moderation     if params[:to_safe_moderation]
    end
    @state = :to_restricted if params[:to_restricted]
    @state = :to_published  if params[:to_published]
    @state = :to_archived   if params[:to_archived]
    @state = :to_unsafe     if params[:to_unsafe]
    @state = :to_draft      if params[:to_draft]
    @state = :clear         if params[:clear]
  end

  def set_topic_state
    unless @moderation_state.blank?
      @topic.send(@moderation_state)  if @topic.respond_to?(@moderation_state)
    end
    unless @state.blank?      
        @topic.send(@state) if @topic.respond_to?(@state)
    end
  end

  def new_comment
    @comment = Comment.new
  end

  def find_comments
    @comments = @topic.comments
  end
end
