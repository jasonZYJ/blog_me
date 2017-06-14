module ApplicationHelper

  def gravatar_url(email)
    email_md5 = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{email_md5}?s=120" #blocked already, not used
  end

  def site_info
    "信息技术分享平台"
  end

  def site_fullname
    "#{Settings.site.name}(#{Settings.site.name_zh})"
  end

  def seo_intro
    "#{Settings.site.name_zh}, #{Settings.site.name}, #{controller_title}, #{meta_keywords}".gsub(' | ', ', ')
  end

  def default_title
    "#{controller_name}/#{action_name}"
  end

  def controller_title
    controller.try(:title) || default_title
  end

  def page_title
    "#{Settings.site.name_zh} | #{controller_title}"
  end

  def meta_keywords
    "关注最近的独家博文、代码分享, 在这里搭建博客、分享博文, 收藏并分享代码, 结识兴趣相投的博主, 相互分享IT信息和技术..."
  end

  def base_search_url
    "https://wen.lu/?gws_rd=cr,ssl#q=site:#{Settings.site.domain}+"
  end

  def omited_str(str, length=60)
    truncate(str, length: length, separator: " ", omission: "...") { yield if block_given? }
  end

  def js_alert(message="非常遗憾，操作失败。")
    render js: "alert('#{message}')"
  end

  def js_reload
    render js: "document.location.reload()"
  end

  def js_reload_without_params
    render js: "window.location.href = location.href.split('?')[0]"
  end

  def draw_errors_message(ist_model)
    ist_model.errors.messages.map do |key, ms|
      ms.map do |m|
        info = t("activerecord.attributes.#{ist_model.class.to_s.underscore}")
        path = if info.is_a?(Hash)
                 "#{info[key.to_sym]}: " if info.key?(key.to_sym)
               end
        "#{path} #{m}"
      end
    end.flatten
  end

  def post_tags_from_str(str)
    str.split(',').map { |tag| "&nbsp;<a target='_blank' href='#{base_search_url}#{tag}'><span class='badge'>#{tag}</span></a>" }.join.html_safe
  end

  def code_tags_from_str(str)
    self.post_tags_from_str(str)
  end

  def show_menubar?
    params[:controller] == 'users' || params[:user_id]
  end

  def user_dropdown_hash
    {
        my_profile: profile_user_path(current_user),
        my_homepage: home_user_path(current_user),
        my_topics: user_path(current_user),
        my_favorite: user_codes_path(current_user)
    }
  end


end
