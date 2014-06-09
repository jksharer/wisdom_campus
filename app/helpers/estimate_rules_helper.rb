module EstimateRulesHelper
	def full_score
		EstimateRule.where(agency: my_agency).pluck(:higher).sort { |a, b| b <=> a }.first
	end
end
