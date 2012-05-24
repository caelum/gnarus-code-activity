#encoding: utf-8

require 'net/http'

class ActivityProcessor
  def self.process(attempt, params)
    exercise = GnarusActivity::Exercise.find(params[:exercise_id])
    verify = exercise.content

    url = EvaluatorService::Config.remote_evaluator + "/please"
    response = nil
    is_correct = false
    begin
      req_params = {code: params[:solution], verify: verify}
      response = Net::HTTP.post_form(URI.parse(url), req_params)
      is_correct = response.is_a?(Net::HTTPSuccess) && response.body == "true"
    rescue SystemCallError => e
      flash[:error] = "Impossível validar o exercício"
    end

    attempt.executions.create(
      solution: params[:solution],
      suceeded: is_correct
	  )
  end
end
