module ApplicationHelper

  def full_title(begin_title = '')
    end_title = "RoR tuto sample app"
    if begin_title.empty?
      end_title
    else
      begin_title + " | " + end_title
    end
  end
end
