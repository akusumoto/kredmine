module CtrlEventAddNewHelper
#---------------------------------------------.
# 「はい」モデル生成.
#---------------------------------------------.
  def createAnswer_YES()
    return EventAnswerData.new_answer(l(:label_default_answer_yes))
  end
	
#---------------------------------------------.
# 「いいえ」モデル生成.
#---------------------------------------------.
  def createAnswer_NO()
    return EventAnswerData.new_answer(l(:label_default_answer_no))
  end

#---------------------------------------------.
# 「空のモデル」モデル生成.
#---------------------------------------------.
  def createAnswer_Empty()
    return EventAnswerData.new_answer(l(:label_default_answer_empty))
  end
	
end


