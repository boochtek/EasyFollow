# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def controller_action
    controller.controller_name + '#' + controller.action_name
  end
end
