class QuizController < ApplicationController

  def call
    params = JSON.parse(env["rack.input"].read)
    resolve(params)
  end

  def resolve(params)
    answer = self.send("level_#{params["level"]}", params["question"])
    task_id = params["id"]
    send_answer(answer, task_id)
  end

  def level_1(question)
    $data_1[normalize(question)]
  end

  def level_2(question)
    $data_2345[normalize(question)]
  end

  def level_3(question)
    question.split("\n").map {|line| $data_2345[normalize(line)] }.join(',')
  end

  def level_4(question)
    question.split("\n").map {|line| $data_2345[normalize(line)] }.join(',')
  end

  def level_5(question)
    normalized = normalize(question)
    words = normalized.scan(/[#{WORD}]+/)
    strings = words.map {|word| normalized.sub(word, "%word%") }
    answers = strings.map {|string| $data_2345[string]}
    index = answers.index {|x| !x.nil?}
    "#{answers[index]},#{words[index]}"
  end

  def level_6(question)
    $data_67[normalize(question).chars.sort]
  end

  def level_7(question)
    $data_67[normalize(question).chars.sort]
  end

  def level_8(question)
    arr = del_simbols(question).chars
    $data_8[arr.size].select{|k,v| (1..2).include? (arr - k | k - arr).size}.values[0]
  end

  def send_answer(answer, task_id)
      data = { answer: answer, token: TOKEN, task_id: task_id}
      res=Net::HTTP.post_form(ADDR, data)
      render json: 'ok'
  end

end
