module AgenciesHelper
	include IclassesHelper

	def behaviors_count_of_agency(agency)
		count = 0
		agency.iclasses.map { |iclass| count += behaviors_count_of_class(iclass) }
		return count
	end

end
