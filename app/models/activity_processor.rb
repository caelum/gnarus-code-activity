require 'net/http'

class ActivityProcessor
  def self.process(attempt, params)
    exercise = GnarusActivity::Exercise.find(params[:exercise_id])
    verify = exercise.content

    uri = URI(EvaluatorService::Config.remote_evaluator + "/please")
    response = Net::HTTP.post_form(uri, code: params[:solution], verify: verify)
    is_correct = response.body == "true"

    attempt.executions.create(
      solution: params[:solution],
      suceeded: is_correct
	  )
  end
end
