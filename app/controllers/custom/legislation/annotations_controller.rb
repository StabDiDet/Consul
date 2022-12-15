require_dependency Rails.root.join("app", "controllers", "legislation", "annotations_controller").to_s

class Legislation::AnnotationsController < Legislation::BaseController
  def comments
    @annotation = Legislation::Annotation.find(params[:annotation_id])
    @draft_version = @annotation.draft_version
    @current_projekt = @draft_version.process.projekt
    @comment = @annotation.comments.new
  end

  def new_comment
    @draft_version = Legislation::DraftVersion.find(params[:draft_version_id])
    @annotation = @draft_version.annotations.find(params[:annotation_id])
    @comment = @annotation.comments.new(body: params[:comment][:body], user: current_user)

    @current_projekt = @draft_version.process.projekt #custom line
    if @comment.save
      @comment = @annotation.comments.new
    end

    respond_to do |format|
      format.js { render :new_comment }
    end
  end
end
