module CtrlEventAddNewHelper
#---------------------------------------------.
# 「はい」モデル生成.
#---------------------------------------------.
  def createAnswer_YES()
    now_answer = EventAnswerData.new
    now_answer.answer_subject = l(:label_default_answer_yes)
    return now_answer
  end
	
#---------------------------------------------.
# 「いいえ」モデル生成.
#---------------------------------------------.
  def createAnswer_NO()
    now_answer = EventAnswerData.new
    now_answer.answer_subject = l(:label_default_answer_no)
    return now_answer
  end
	
	def remote_function(options)
    ("$.ajax({url: '#{ url_for(options[:url]) }', type: '#{ options[:method] || 'GET' }', " +
    "data: #{ options[:with] ? options[:with] + '&amp;' : '' } + " +
    "'authenticity_token=' + encodeURIComponent('#{ form_authenticity_token }')" +
    (options[:data_type] ? ", dataType: '" + options[:data_type] + "'" : "") +
    (options[:success] ? ", success: function(response) {" + options[:success] + "}" : "") +
    (options[:before] ? ", beforeSend: function(data) {" + options[:before] + "}" : "") + "});").html_safe
end
end


